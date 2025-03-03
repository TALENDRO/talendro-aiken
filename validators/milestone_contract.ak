///////////below is for substitution------------------------
//////////////////////////----------------------------------------------

use cardano/assets.{PolicyId}
use cardano/transaction.{Transaction}
use types.{ProjectDatum, ProjectRedeemer}
use utils1

validator milestone_contract_spend(config_nft: PolicyId) {
  spend(
    datum: Option<ProjectDatum>,
    redeemer: ProjectRedeemer,
    _oref,
    tx: Transaction,
  ) {
    utils1.spend_milestone(datum, redeemer, config_nft, tx)
  }

  else(_) {
    fail
  }
}

validator milestone_contract_mint(config_nft: PolicyId) {
  mint(redeemer: ProjectRedeemer, policy_id: PolicyId, tx: Transaction) {
    utils1.mint_milestone(redeemer, config_nft, policy_id, tx)
  }

  else(_) {
    fail
  }
}
