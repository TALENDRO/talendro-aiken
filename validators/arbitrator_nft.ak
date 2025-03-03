// this validator mints an NFT for arbitrator identification and only person who can mint is someone holding identification_NFT
use cardano/assets.{PolicyId}
use cardano/transaction.{Transaction}
use mint_utils

validator arbitrator_nft(identification_nft: PolicyId) {
  mint(_redeemer, policy_id: PolicyId, tx: Transaction) {
    let Transaction { mint, inputs, .. } = tx
    expect [Pair(_, token_qty)] = mint_utils.tokens_details(mint, policy_id)
    when token_qty is {
      1 | -1 ->
        mint_utils.must_have_identification_nft(inputs, identification_nft)
      _ -> fail
    }
  }

  else(_) {
    fail
  }
}
