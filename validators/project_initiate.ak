use aiken/primitive/bytearray
use cardano/address.{Script, VerificationKey}
use cardano/assets.{PolicyId}
use cardano/transaction.{
  Output, OutputReference, Transaction, find_input, find_script_outputs,
}
use datum_file as d
use mint_utils
use types.{ConfigDatum, ProjectDatum}
use utils

// redeemer
// 0 -> developer calls
// 1 -> admin calls

/// this validator is to create a project 
/// to create a project client will mint a project token and send it to the self_script
/// to accept this project the developer will withdraw the token and send the utxo with ADA to HOLDING_CONTRACT
validator project_initiator(config_nft: PolicyId) {
  spend(
    datum: Option<ProjectDatum>,
    redeemer: Int,
    oref: OutputReference,
    tx: Transaction,
  ) {
    expect Some(datum) = datum
    let Transaction {
      inputs,
      reference_inputs,
      outputs,
      extra_signatories,
      mint,
      ..
    } = tx
    expect Some(input_utxo) = find_input(inputs, oref)
    expect Script(policy_id) = input_utxo.output.address.payment_credential
    when redeemer is {
      // Accept the Project
      1 -> {
        // find ref_input and Datum type
        let config_datum = utils.get_config_datum(reference_inputs, config_nft)
        // -----
        let dev_output = utils.find_output_with_policy(outputs, policy_id)
        expect VerificationKey(vk_hash) = dev_output.address.payment_credential
        // same datum expect projectDatum.developer
        let contract_output = utils.find_output_with_datum(outputs, datum)
        let output_datum: ProjectDatum =
          d.output_to_project_datum(contract_output)

        // (output_datum.developer == nft )
        and {
          utils.must_have_x_token(
            reference_inputs,
            config_datum.talendrouser_nft,
          )?,
          when output_datum.developer is {
            Some((vkh, skh)) ->
              utils.address_from_tuple((vkh, skh)) == dev_output.address
            None -> fail
          }?,
          utils.must_send_to_correct_script(
            contract_output,
            datum.pay,
            config_datum,
          )?,
          utils.must_be_signed_by(extra_signatories, vk_hash)?,
        }
      }
      // Cancelling the Project
      2 -> and {
          utils.must_pay_to_client(outputs, datum)?,
          utils.must_burn_dev_clt_token(mint, policy_id)?,
        }
      _ -> False
    }
  }

  /// mint 2 project token with names as clt_projectName dev_projectName and confirms for the correct datum
  mint(redeemer: Int, policy_id: PolicyId, tx: Transaction) {
    let Transaction { outputs, reference_inputs, mint, .. } = tx
    // find ref_input and Datum type
    when redeemer is {
      // 0 = MINT
      0 -> {
        let ref_input =
          utils.find_ref_input_with_config_nft(reference_inputs, config_nft)
        // expect InlineDatum(output_datum) = ref_input.output.datum
        let config_datum: ConfigDatum = d.input_to_config_datum(ref_input)
        // -----
        // finding script output and Inlinedatum
        expect [script_output]: List<Output> =
          find_script_outputs(outputs, policy_id)
        let script_datum: ProjectDatum =
          d.output_to_project_datum(script_output)
        // -----
        // finding clt_ dev_ tokens 
        expect [Pair(clt_token_name, 1),
          Pair(dev_token_name, 1)] = mint_utils.tokens_details(mint, policy_id)
        expect #"636c745f" = clt_token_name |> bytearray.take(4)
        expect #"6465765f" = dev_token_name |> bytearray.take(4)

        // #"636c745f" == clt_  && #"6465765f == dev_
        // -----
        // ------------------------- //
        // must have talendro token -> ref input -> ConfigDatum Match .talendro
        // must send correct datum to script
        and {
          utils.find_stake_input_by_address(
            reference_inputs,
            config_datum.stake_vkh.1st,
          ),
          utils.must_have_x_token(
            reference_inputs,
            config_datum.talendrouser_nft,
          )?,
          // token name must be same
          (bytearray.drop(dev_token_name, 4) == bytearray.drop(
            clt_token_name,
            4,
          ))?,
          // dev_ must go to script
          utils.must_have_token_in_output(
            script_output,
            dev_token_name,
            policy_id,
          )?,
          // projectDatum.pay == ada to script output if None then True
          utils.ada_to_script_address(script_output, script_datum.pay)?,
        }
      }
      // 1 = BURN
      1 -> utils.must_burn_dev_clt_token(mint, policy_id)?
      _ -> False
    }
  }

  else(_) {
    fail
  }
}
