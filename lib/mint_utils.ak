use aiken/collection/dict
use aiken/collection/list
use cardano/assets.{AssetName, PolicyId, Value, policies}
use cardano/transaction.{Input}

pub fn tokens_details(
  value: Value,
  policy_id: PolicyId,
) -> Pairs<AssetName, Int> {
  value
    |> assets.tokens(policy_id)
    |> dict.to_pairs
}

pub fn must_have_identification_nft(inputs: List<Input>, policy_id: PolicyId) {
  list.any(
    inputs,
    fn(input) { policies(input.output.value) |> list.has(policy_id) },
  )
}
