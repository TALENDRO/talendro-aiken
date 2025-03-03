use cardano/assets.{PolicyId}
use cardano/transaction.{Input, Transaction}
use types.{ArbitrationDatum, ArbitrationRedeemer}
use utils

/// Arbitrator releases the payment to either client or developer and consumes its staked ADA
validator arbitration(config_nft: PolicyId) {
  spend(
    datum: Option<ArbitrationDatum>,
    redeemer: ArbitrationRedeemer,
    _oref,
    tx: Transaction,
  ) {
    expect Some(datum) = datum
    let Transaction { inputs, reference_inputs, outputs, .. } = tx

    let config_datum = utils.get_config_datum(reference_inputs, config_nft)
    let arb_policy_id = config_datum.arbitrator_nft
    let stake_vkh = config_datum.stake_vkh
    let staked_input: Input =
      utils.find_input_with_address(inputs, utils.address_from_tuple(stake_vkh))

    and {
      utils.must_have_x_token(inputs, arb_policy_id),
      when redeemer.payto is {
        0 -> and {
            utils.is_consuming_staked_ada(staked_input, datum, redeemer.payto),
            utils.must_pay_to_client(outputs, datum.project_datum),
          }
        1 -> and {
            utils.is_consuming_staked_ada(staked_input, datum, redeemer.payto),
            utils.must_pay_to_developer(outputs, datum.project_datum),
          }
        _ -> False
      },
    }
  }

  else(_) {
    fail
  }
}
