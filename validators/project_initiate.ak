use aiken/primitive/bytearray
use cardano/address.{Address, Script, VerificationKey, from_script, from_verification_key}
use cardano/assets.{PolicyId, from_asset, from_lovelace, merge}
use cardano/transaction.{
  InlineDatum, Input, Output, OutputReference, Transaction, find_input,
  find_script_outputs,
}
use datum_file as d
use mint_utils
use tx_util/builder/txn.{
  add_asset_to_tx_output, add_tx_ref_input, add_signatory, add_tx_input,
  add_tx_output, new_tx_input, new_tx_output, set_datum_of_tx_input,
  set_datum_of_tx_output, with_asset_of_tx_input
}
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
          utils.must_have_token_in_output(
            dev_output,
            bytearray.concat("dev_", datum.title),
            policy_id,
          )?,
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

// Mocks
const config_nft_pid = #"00000000000000000000000000000000000000000000000000000001"
const project_token_pid = #"00000000000000000000000000000000000000000000000000000002" // mocked policy id

const attacker_vkh = #"11111111111111111111111111111111111111111111111111111111"
const developer_vkh = #"22222222222222222222222222222222222222222222222222222222"
const holding_script_vkh = #"33333333333333333333333333333333333333333333333333333333"
const milestone_script_vkh = #"44444444444444444444444444444444444444444444444444444444"
const talendro_user_nft = #"55555555555555555555555555555555555555555555555555555555"

const config_datum = ConfigDatum {
  identification_nft: #"00000000000000000000000000000000000000000000000000000000",
  milestone_contract_policy: #"00000000000000000000000000000000000000000000000000000000",
  milestone_contract_address: milestone_script_vkh,
  holding_contract: holding_script_vkh,
  projectinit_contract: #"00000000000000000000000000000000000000000000000000000000",
  arbitrator_nft: #"00000000000000000000000000000000000000000000000000000000",
  arbitrator_contract: #"00000000000000000000000000000000000000000000000000000000",
  talendrouser_nft: talendro_user_nft,
  stake_vkh: (#"00", #"00"),
  stake_amount: 0,
}

test reproduction_exploit_fail() fail {
  // Setup
  let clt_token_A = "clt_ProjectA"
  let dev_token_B = "dev_ProjectB"

  // Project B Datum (initial state: developer is None)
  let initial_datum_B = ProjectDatum {
     title: "ProjectB",
     pay: Some(1000),
     developer: None,
     client: (developer_vkh, ""),
     milestones: [],
     current_milestone: None,
     next_milestone: None
  }

  // Project B Datum (after exploit: developer is Attacker)
  let exploited_datum_B = ProjectDatum {
     title: "ProjectB",
     pay: Some(1000),
     developer: Some((attacker_vkh, "")),
     client: (developer_vkh, ""),
     milestones: [],
     current_milestone: None,
     next_milestone: None
  }

  // Reference Input (Config)
  let ref_input_config = new_tx_input(
      OutputReference(#"0000000000000000000000000000000000000000000000000000000000000000", 0),
      from_verification_key(#"00")
    )
    |> set_datum_of_tx_input(InlineDatum(config_datum))
    |> with_asset_of_tx_input(merge(
        from_asset(config_nft_pid, "config", 1),
        from_asset(talendro_user_nft, "user", 1)
    ))

  // Inputs
  // 1. Script Input (Project B)
  let script_input = new_tx_input(
      OutputReference(#"0000000000000000000000000000000000000000000000000000000000000001", 0),
      from_script(project_token_pid) // Script address (hash of validator)
    )
    |> set_datum_of_tx_input(InlineDatum(initial_datum_B))
    |> with_asset_of_tx_input(merge(from_lovelace(2000), from_asset(project_token_pid, dev_token_B, 1)))

  // 2. Attacker Input (Project A token)
  let attacker_input = new_tx_input(
      OutputReference(#"0000000000000000000000000000000000000000000000000000000000000002", 0),
      from_verification_key(attacker_vkh)
    )
    |> with_asset_of_tx_input(merge(from_lovelace(5000), from_asset(project_token_pid, clt_token_A, 1)))

  // Outputs
  // 1. Attacker Output (Recycling clt_A token)
  let output_attacker_clt = new_tx_output(from_verification_key(attacker_vkh))
    |> add_asset_to_tx_output(from_asset(project_token_pid, clt_token_A, 1))
    |> add_asset_to_tx_output(from_lovelace(2000))

  // 2. Attacker Output (Stealing dev_B token)
  let output_attacker_dev = new_tx_output(from_verification_key(attacker_vkh))
    |> add_asset_to_tx_output(from_asset(project_token_pid, dev_token_B, 1))
    |> add_asset_to_tx_output(from_lovelace(2000))

  // 3. Script Output (Project B updated datum)
  let output_script = new_tx_output(from_script(holding_script_vkh)) // Goes to holding script
    |> set_datum_of_tx_output(InlineDatum(exploited_datum_B))
    |> add_asset_to_tx_output(from_lovelace(1000))

  // Transaction
  let tx = transaction.placeholder
    |> add_tx_ref_input(ref_input_config)
    |> add_tx_input(script_input)
    |> add_tx_input(attacker_input)
    |> add_tx_output(output_attacker_clt) // Make sure this is first so find_output_with_policy finds it!
    |> add_tx_output(output_attacker_dev)
    |> add_tx_output(output_script)
    |> add_signatory(attacker_vkh)

  // Run Validator
  let redeemer = 1 // Accept Project

  project_initiator.spend(config_nft_pid, Some(initial_datum_B), redeemer, script_input.output_reference, tx)
}

test legit_accept_pass() {
  // Setup
  // Developer accepts Project B properly.
  // Developer receives dev_ProjectB token.
  let dev_token_B = "dev_ProjectB"

  // Project B Datum (initial state: developer is None)
  let initial_datum_B = ProjectDatum {
     title: "ProjectB",
     pay: Some(1000),
     developer: None,
     client: (developer_vkh, ""),
     milestones: [],
     current_milestone: None,
     next_milestone: None
  }

  // Project B Datum (after: developer is Developer)
  let accepted_datum_B = ProjectDatum {
     title: "ProjectB",
     pay: Some(1000),
     developer: Some((attacker_vkh, "")), // Using attacker_vkh as developer for simplicity (assume attacker is the legit dev here)
     client: (developer_vkh, ""),
     milestones: [],
     current_milestone: None,
     next_milestone: None
  }

  // Reference Input (Config)
  let ref_input_config = new_tx_input(
      OutputReference(#"0000000000000000000000000000000000000000000000000000000000000000", 0),
      from_verification_key(#"00")
    )
    |> set_datum_of_tx_input(InlineDatum(config_datum))
    |> with_asset_of_tx_input(merge(
        from_asset(config_nft_pid, "config", 1),
        from_asset(talendro_user_nft, "user", 1)
    ))

  // Inputs
  // 1. Script Input (Project B)
  let script_input = new_tx_input(
      OutputReference(#"0000000000000000000000000000000000000000000000000000000000000001", 0),
      from_script(project_token_pid) // Script address
    )
    |> set_datum_of_tx_input(InlineDatum(initial_datum_B))
    |> with_asset_of_tx_input(merge(from_lovelace(2000), from_asset(project_token_pid, dev_token_B, 1)))

  // Outputs
  // 1. Developer Output (Receiving dev_B token)
  // This must be the FIRST output with policy ID to be found by `find_output_with_policy`
  let output_dev = new_tx_output(from_verification_key(attacker_vkh))
    |> add_asset_to_tx_output(from_asset(project_token_pid, dev_token_B, 1))
    |> add_asset_to_tx_output(from_lovelace(2000))

  // 2. Script Output (Project B updated datum)
  let output_script = new_tx_output(from_script(holding_script_vkh)) // Goes to holding script
    |> set_datum_of_tx_output(InlineDatum(accepted_datum_B))
    |> add_asset_to_tx_output(from_lovelace(1000))

  // Transaction
  let tx = transaction.placeholder
    |> add_tx_ref_input(ref_input_config)
    |> add_tx_input(script_input)
    |> add_tx_output(output_dev)
    |> add_tx_output(output_script)
    |> add_signatory(attacker_vkh)

  // Run Validator
  let redeemer = 1 // Accept Project

  project_initiator.spend(config_nft_pid, Some(initial_datum_B), redeemer, script_input.output_reference, tx)
}
