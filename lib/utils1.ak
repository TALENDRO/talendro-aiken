////-------------------XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX-------------------------

use aiken/primitive/bytearray
use cardano/address.{from_verification_key}
use cardano/assets.{PolicyId}
use cardano/transaction.{Input, Output, OutputReference, Transaction}
use datum_file as d
use mint_utils
use types.{Cancel, Complete, ConfigDatum, Create, ProjectDatum, ProjectRedeemer}
use utils

//----------------MINTING MILESTONE---------------------------////
pub fn mint_milestone(
  action: ProjectRedeemer,
  config_nft: PolicyId,
  //   config_datum: ConfigDatum,
  //   prj_datum: ProjectDatum,
  policy_id: PolicyId,
  tx: Transaction,
) {
  let config_datum: ConfigDatum =
    utils.get_config_datum(tx.reference_inputs, config_nft)
  when action is {
    Create -> tx |> milestone_mint_create(config_datum, policy_id)
    Complete -> tx |> milestone_mint_compelete(config_datum, policy_id)
    Cancel -> tx |> milestone_mint_cancel(config_datum, policy_id)
    _ -> False
  }
}

pub fn milestone_mint_create(
  tx: Transaction,
  config_datum: ConfigDatum,
  policy_id: PolicyId,
) {
  let milestone_input: Input =
    utils.find_input_with_address(
      tx.inputs,
      utils.script_address_from_tuple(
        (config_datum.milestone_contract_address, ""),
      ),
    )

  let milestone_datum: ProjectDatum = d.input_to_project_datum(milestone_input)

  let holding_contract_utxo: Output =
    utils.find_output_with_datum(tx.outputs, milestone_datum)

  let holding_contract_datum: ProjectDatum =
    d.output_to_project_datum(holding_contract_utxo)
  expect Some(dev_address) = milestone_datum.developer
  let dev_output: Output =
    utils.find_output_with_address(
      tx.outputs,
      utils.address_from_tuple(dev_address),
    )
  and {
    utils.output_must_have_dev_or_clt_tokens(
      dev_output,
      policy_id,
      holding_contract_datum,
      "dev_",
    )?,
    //  below function also check for qty == 1
    utils.confirm_minting_token_with_milestones(
      tx.mint,
      holding_contract_datum,
      policy_id,
    )?,
    utils.correct_milestone_ada_to_script(
      holding_contract_utxo,
      holding_contract_datum.current_milestone,
    )?,
    (holding_contract_utxo.address == from_verification_key(
      config_datum.holding_contract,
    ))?,
  }
}

pub fn milestone_mint_compelete(
  tx: Transaction,
  config_datum: ConfigDatum,
  policy_id: PolicyId,
) {
  let input_project_datum: ProjectDatum =
    utils.find_input_with_address(
      tx.inputs,
      utils.script_address_from_tuple((config_datum.holding_contract, "")),
    )
      |> d.input_to_project_datum

  let holding_contract_output =
    utils.find_output_with_address(
      tx.outputs,
      utils.script_address_from_tuple((config_datum.holding_contract, "")),
    )
  let output_project_datum: ProjectDatum =
    d.output_to_project_datum(holding_contract_output)
  and {
    utils.must_burn_dev_clt_milestone_token(
      tx.mint,
      policy_id,
      input_project_datum,
    )?,
    utils.correct_milestone_updation(input_project_datum, output_project_datum)?,
    utils.correct_milestone_ada_to_script(
      holding_contract_output,
      output_project_datum.current_milestone,
    )?,
  }
}

pub fn milestone_mint_cancel(
  tx: Transaction,
  config_datum: ConfigDatum,
  policy_id: PolicyId,
) {
  let holding_contract_input: Input =
    utils.find_input_with_address(
      tx.inputs,
      utils.script_address_from_tuple((config_datum.holding_contract, "")),
    )
  let holding_contract_datum: ProjectDatum =
    d.input_to_project_datum(holding_contract_input)
  and {
    utils.datum_for_cancel(holding_contract_datum),
    utils.milestone_tokens_burn_cancel(
      tx.mint,
      policy_id,
      holding_contract_datum,
    ),
  }
}

//-----XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX---------////////////

///---------SPENDNG MILESTONE-----------------------------//////
pub fn spend_milestone(
  datum: Option<ProjectDatum>,
  redeemer: ProjectRedeemer,
  config_nft: PolicyId,
  tx: Transaction,
) {
  expect Some(datum) = datum
  let config_datum: ConfigDatum = utils.get_config_datum(tx.inputs, config_nft)
  let project_init_policyid = config_datum.projectinit_contract

  // expect Script(project_init_policyid) = 
  // config_datum.projectinit_contract.payment_credential
  when redeemer is {
    Create -> tx |> milestone_spend_create(project_init_policyid, config_datum)
    Cancel ->
      tx |> milestone_spend_cancel(datum, config_datum, project_init_policyid)
    _ -> fail
  }
}

pub fn milestone_spend_create(
  tx: Transaction,
  project_init_policyid: PolicyId,
  config_datum: ConfigDatum,
) {
  and {
    utils.find_input_with_policy(tx.inputs, project_init_policyid)?,
    utils.must_have_x_token(tx.inputs, config_datum.talendrouser_nft)?,
  }
}

pub fn milestone_spend_cancel(
  tx: Transaction,
  datum: ProjectDatum,
  config_datum: ConfigDatum,
  project_init_policyid: PolicyId,
) {
  when datum.developer is {
    Some(_) -> {
      let script_hash = config_datum.milestone_contract_address
      // expect Script(script_hash) =
      //   config_datum.milestone_contract_address.payment_credential
      expect [script_utxo] =
        transaction.find_script_outputs(tx.outputs, script_hash)
      let script_datum: ProjectDatum = d.output_to_project_datum(script_utxo)
      and {
        (script_datum.developer == None)?,
        utils.output_must_have_dev_or_clt_tokens(
          script_utxo,
          project_init_policyid,
          script_datum,
          "dev_",
        )?,
        True,
      }
    }
    None -> utils.must_burn_dev_clt_token(tx.mint, project_init_policyid)?
  }
}

//---------------XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX----------------///////

//------------------IDENTIFICATION NFT------------------///
pub fn identification_nft(
  tx: Transaction,
  policy_id: PolicyId,
  oref: OutputReference,
) {
  expect [Pair(ref_token_name, 1),
    Pair(usr_token_name, 1)] = mint_utils.tokens_details(tx.mint, policy_id)
  expect #"7265665f" = ref_token_name |> bytearray.take(4)
  expect #"7573725f" = usr_token_name |> bytearray.take(4)
  // ref_ goes to config UTXO and usr_ goes to admin for Arbitator token minting control
  and {
    bytearray.drop(usr_token_name, 4) == bytearray.drop(ref_token_name, 4),
    utils.must_consume_oref(tx.inputs, oref),
  }
}
//-------------XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX-----------------///
