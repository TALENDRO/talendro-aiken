use aiken/collection/list
use cardano/assets.{PolicyId}
use cardano/transaction.{OutputReference, Transaction}

/// holds the config datum with config NFT
validator config_datum_holder(config_nft: PolicyId) {
  spend(_datum, _redeemer, oref: OutputReference, tx: Transaction) {
    let Transaction { inputs, .. } = tx
    let inputs_with_nft =
      list.filter(
        inputs,
        fn(input) {
          list.has(input.output.value |> assets.policies, config_nft)
        },
      )

    when list.length(inputs_with_nft) is {
      2 -> True
      1 ->
        when list.head(inputs_with_nft) is {
          None -> False
          Some(input) -> input.output_reference != oref
        }
      _ -> fail
    }
  }

  else(_) {
    fail
  }
}
