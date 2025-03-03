use cardano/assets.{PolicyId}
use cardano/transaction.{OutputReference, Transaction}
use utils1

///mints the Identification NFT
validator identification_nft(oref: OutputReference) {
  mint(_redeemer, policy_id: PolicyId, tx: Transaction) {
    trace @"identification Nft policyId": tx.inputs
    utils1.identification_nft(tx, policy_id, oref)
  }

  else(_) {
    fail
  }
}
