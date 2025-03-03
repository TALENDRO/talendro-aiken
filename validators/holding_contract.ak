use aiken/collection/dict
use cardano/address.{Script}
use cardano/assets.{PolicyId}
use cardano/transaction.{
  Output, OutputReference, Transaction, find_input, find_script_outputs,
}
use datum_file as d
use types.{
  ArbitrationDatum, Arbitrator, Cancel, Complete, ConfigDatum, ProjectDatum,
  ProjectRedeemer,
}
use utils

/// holds the ADA till the project is completed or canceled (ESCROW ACCOUNT) 
/// manages the Cancel and Complete functionality
/// handles the arbitrator action
validator holding_contract(config_nft: PolicyId) {
  spend(
    datum: Option<ProjectDatum>,
    redeemer: ProjectRedeemer,
    oref: OutputReference,
    tx: Transaction,
  ) {
    expect Some(datum) = datum
    let Transaction { inputs, reference_inputs, outputs, mint, .. } = tx

    expect Some(script_input) = find_input(inputs, oref)
    let config_datum = utils.get_config_datum(reference_inputs, config_nft)
    let project_init_policyid = config_datum.projectinit_contract
    expect Script(script_hash) = script_input.output.address.payment_credential

    let dev_token =
      assets.tokens(script_input.output.value, project_init_policyid)
    when redeemer is {
      // if the dev token is not available 
      // then complete will run the False part which is taking developer's complete action
      // otherwise it will run True part which is clients complete action and releases the payment to Developer
      Complete ->
        when dict.is_empty(dev_token) is {
          True -> {
            expect [script_output] = find_script_outputs(outputs, script_hash)
            and {
              utils.output_must_have_dev_token(
                script_output,
                project_init_policyid,
                datum,
              ),
              script_input.output.datum == script_output.datum,
              assets.lovelace_of(script_input.output.value) <= assets.lovelace_of(
                script_output.value,
              ),
            }
          }
          False -> and {
              // DONE = should burn dev_ & clt_
              utils.must_burn_dev_clt_token(mint, project_init_policyid),
              // DONE = projectdatum.pay == ada and must send to projectdatum.developer
              utils.must_pay_to_developer(outputs, datum),
            }
        }

      // if the dev token is not available 
      // then complete will run the False part which is taking developer's cancel action
      // otherwise it will run True part which is clients cancel action and releases the payment to client
      Cancel ->
        when dict.is_empty(dev_token) is {
          // Developer
          True -> {
            expect [script_output] = find_script_outputs(outputs, script_hash)
            let project_script_datum = d.output_to_project_datum(script_output)
            and {
              utils.output_must_have_dev_token(
                script_output,
                project_init_policyid,
                datum,
              ),
              project_script_datum.developer == None,
              project_script_datum.pay == None,
              assets.lovelace_of(script_input.output.value) <= assets.lovelace_of(
                script_output.value,
              ),
            }
          }
          // Client
          // CLIENT =  should burn dev_ & clt_
          //    ada goes to datum.client
          False -> and {
              utils.must_burn_dev_clt_token(mint, project_init_policyid)?,
              utils.must_pay_to_client(outputs, datum)?,
            }
        }

      // calls the Arbitrator Action
      // send the utxo to ARBITRATION_CONTRACT
      Arbitrator -> {
        let arbitrator_output: Output =
          utils.find_output_with_address(
            outputs,
            utils.script_address_from_tuple(
              (config_datum.arbitrator_contract, ""),
            ),
          )
        let arbitration_datum = d.output_to_arbitration_datum(arbitrator_output)
        and {
          utils.output_must_have_prj_token(
            arbitrator_output,
            project_init_policyid,
            datum,
          )?,
          (arbitration_datum.project_datum == datum)?,
          (assets.lovelace_of(arbitrator_output.value) >= assets.lovelace_of(
            script_input.output.value,
          ))?,
        }
      }
      _ -> False
    }
  }

  else(_) {
    fail
  }
}
