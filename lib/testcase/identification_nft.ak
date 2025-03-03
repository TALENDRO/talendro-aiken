// use cardano/address.{from_verification_key}
// use cardano/assets.{from_asset}
// use cardano/transaction
// use mocktail.{mock_utxo_ref}
// use mocktail/virgin_key_hash.{mock_policy_id}
// use tx_util/builder/txn.{
//   add_asset_to_tx_output, add_mint, add_tx_input, add_tx_output,
// }
// use utils1

// pub const oref = mock_utxo_ref(0, 0)

// pub const policy_id = mock_policy_id(0)

// test identification_nft_pass() {
//   let address1 = from_verification_key("abc")
//   let value = from_asset(mock_policy_id(0), "ref_", 1)
//   let value1 = from_asset(mock_policy_id(0), "usr_", 1)
//   let tx_input = txn.new_tx_input(oref, address1)

//   let tx_output_1 =
//     txn.new_tx_output(address1)
//       |> add_asset_to_tx_output(value)
//       |> add_asset_to_tx_output(value1)
//       |> add_asset_to_tx_output(assets.from_lovelace(21))

//   let tx =
//     transaction.placeholder
//       |> add_tx_input(tx_input)
//       |> add_mint(value)
//       |> add_mint(value1)
//       |> add_tx_output(tx_output_1)

//   utils1.identification_nft(tx, policy_id, oref)
// }

// test identification_nft_REF_diff_name() fail {
//   let address1 = from_verification_key("abc")
//   let value = from_asset(mock_policy_id(0), "reaf_", 1)
//   //passing differnet name
//   let value1 = from_asset(mock_policy_id(0), "usr_", 1)
//   let tx_input = txn.new_tx_input(oref, address1)

//   let tx_output_1 =
//     txn.new_tx_output(address1)
//       |> add_asset_to_tx_output(value)
//       |> add_asset_to_tx_output(value1)
//       |> add_asset_to_tx_output(assets.from_lovelace(21))

//   let tx =
//     transaction.placeholder
//       |> add_tx_input(tx_input)
//       |> add_mint(value)
//       |> add_mint(value1)
//       |> add_tx_output(tx_output_1)

//   utils1.identification_nft(tx, policy_id, oref)
// }

// test identification_nft_USR_diff_name() fail {
//   let address1 = from_verification_key("abc")
//   let value = from_asset(mock_policy_id(0), "ref_", 1)
//   let value1 = from_asset(mock_policy_id(0), "usar_", 1)
//   //passing differnet name
//   let tx_input = txn.new_tx_input(oref, address1)

//   let tx_output_1 =
//     txn.new_tx_output(address1)
//       |> add_asset_to_tx_output(value)
//       |> add_asset_to_tx_output(value1)
//       |> add_asset_to_tx_output(assets.from_lovelace(21))

//   let tx =
//     transaction.placeholder
//       |> add_tx_input(tx_input)
//       |> add_mint(value)
//       |> add_mint(value1)
//       |> add_tx_output(tx_output_1)

//   utils1.identification_nft(tx, policy_id, oref)
// }

// test identification_nft_Diff_OREF() fail {
//   let address1 = from_verification_key("abc")
//   let value = from_asset(mock_policy_id(0), "ref_", 1)
//   let value1 = from_asset(mock_policy_id(0), "usr_", 1)

//   let oref1 = mock_utxo_ref(1, 0)

//   let tx_input = txn.new_tx_input(oref1, address1)

//   //passing different oref
//   let tx_output_1 =
//     txn.new_tx_output(address1)
//       |> add_asset_to_tx_output(value)
//       |> add_asset_to_tx_output(value1)
//       |> add_asset_to_tx_output(assets.from_lovelace(21))

//   let tx =
//     transaction.placeholder
//       |> add_tx_input(tx_input)
//       |> add_mint(value)
//       |> add_mint(value1)
//       |> add_tx_output(tx_output_1)

//   utils1.identification_nft(tx, policy_id, oref)
// }
