// use cardano/address.{from_verification_key}
// use cardano/assets.{from_asset}
// use cardano/transaction.{InlineDatum}
// // use mocktail.{mock_utxo_ref}
// use mocktail/virgin_key_hash.{mock_policy_id}
// use testcase/constant.{
//   campaign_nonce, config_datum, mil1, mil2, policy_id, prj_datum, value, value1,
// }
// use tx_util/builder/txn.{
//   add_asset_to_tx_output, add_mint, add_tx_input, add_tx_output,
//   set_datum_of_tx_input, set_datum_of_tx_output,
// }
// use types.{ConfigDatum, ProjectDatum}
// use utils1

// pub const out_prj_datum =
//   ProjectDatum {
//     title: "title",
//     pay: Some(10),
//     developer: Some(from_verification_key("abc")),
//     client: from_verification_key("abc"),
//     milestones: [mil2],
//     current_milestone: Some(mil2),
//     next_milestone: Some(mil1),
//   }

// test create_milestone_pass() {
//   let out_prj_datum =
//     ProjectDatum {
//       ..prj_datum,
//       milestones: [mil2],
//       current_milestone: Some(mil2),
//     }

//   let address1 = config_datum.milestone_contract_address

//   expect Some(dev_address1) = prj_datum.developer
//   let tx_input =
//     txn.new_tx_input(campaign_nonce, address1)
//       |> set_datum_of_tx_input(InlineDatum(prj_datum))

//   let tx_output_1 =
//     txn.new_tx_output(dev_address1)
//       |> add_asset_to_tx_output(value)
//       |> add_asset_to_tx_output(value1)
//       |> set_datum_of_tx_output(InlineDatum(out_prj_datum))
//       |> add_asset_to_tx_output(assets.from_lovelace(21))

//   let tx =
//     transaction.placeholder
//       |> add_tx_input(tx_input)
//       |> add_mint(value)
//       |> add_mint(value1)
//       |> add_tx_output(tx_output_1)

//   utils1.milestone_mint_create(tx, config_datum, policy_id)
// }

// test create_milestone_output_dont_have_any_token_fail() fail {
//   let address1 = from_verification_key("abc")

//   expect Some(dev_address1) = prj_datum.developer
//   let tx_input =
//     txn.new_tx_input(campaign_nonce, address1)
//       |> set_datum_of_tx_input(InlineDatum(prj_datum))

//   let tx_output_1 =
//     txn.new_tx_output(dev_address1) // |> add_asset_to_tx_output(value)
//       // |> add_asset_to_tx_output(value1)
//       |> set_datum_of_tx_output(InlineDatum(out_prj_datum))
//       |> add_asset_to_tx_output(assets.from_lovelace(13))

//   let tx =
//     transaction.placeholder
//       |> add_tx_input(tx_input)
//       |> add_mint(value)
//       |> add_mint(value1)
//       |> add_tx_output(tx_output_1)

//   utils1.milestone_mint_create(tx, config_datum, policy_id)
// }

// test create_milestone_diff_PID_fail() fail {
//   let address1 = from_verification_key("abc")
//   let value = from_asset(mock_policy_id(0), "dev_dev_mile", 1)
//   let value1 = from_asset(mock_policy_id(0), "clt_dev_mile", 1)
//   expect Some(dev_address1) = prj_datum.developer
//   let tx_input =
//     txn.new_tx_input(campaign_nonce, address1)
//       |> set_datum_of_tx_input(InlineDatum(prj_datum))

//   let tx_output_1 =
//     txn.new_tx_output(dev_address1)
//       |> add_asset_to_tx_output(value)
//       |> add_asset_to_tx_output(value1)
//       |> set_datum_of_tx_output(InlineDatum(out_prj_datum))
//       |> add_asset_to_tx_output(assets.from_lovelace(21))

//   let tx =
//     transaction.placeholder
//       |> add_tx_input(tx_input)
//       |> add_mint(value)
//       |> add_mint(value1)
//       |> add_tx_output(tx_output_1)
//   // ----------------------------passing a different PID
//   let policy_id = mock_policy_id(1)
//   utils1.milestone_mint_create(tx, config_datum, policy_id)
// }

// test create_milestone_token_qty_2_fail() fail {
//   let address1 = from_verification_key("abc")
//   //-------------------------------------- qty is more than 1 
//   let value = from_asset(mock_policy_id(0), "dev_title_mile", 2)
//   let value1 = from_asset(mock_policy_id(0), "clt_title_mile", 2)
//   expect Some(dev_address1) = prj_datum.developer
//   let tx_input =
//     txn.new_tx_input(campaign_nonce, address1)
//       |> set_datum_of_tx_input(InlineDatum(prj_datum))

//   let tx_output_1 =
//     txn.new_tx_output(dev_address1)
//       |> add_asset_to_tx_output(value)
//       |> add_asset_to_tx_output(value1)
//       |> set_datum_of_tx_output(InlineDatum(out_prj_datum))
//       |> add_asset_to_tx_output(assets.from_lovelace(21))

//   let tx =
//     transaction.placeholder
//       |> add_tx_input(tx_input)
//       |> add_mint(value)
//       |> add_mint(value1)
//       |> add_tx_output(tx_output_1)

//   utils1.milestone_mint_create(tx, config_datum, policy_id)
// }

// test create_milestone_mint_1Mile_token_fail() fail {
//   let address1 = from_verification_key("abc")

//   expect Some(dev_address1) = prj_datum.developer
//   let tx_input =
//     txn.new_tx_input(campaign_nonce, address1)
//       |> set_datum_of_tx_input(InlineDatum(prj_datum))

//   let tx_output_1 =
//     txn.new_tx_output(dev_address1)
//       |> add_asset_to_tx_output(value)
//       |> add_asset_to_tx_output(value1)
//       |> set_datum_of_tx_output(InlineDatum(out_prj_datum))
//       |> add_asset_to_tx_output(assets.from_lovelace(21))

//   let tx =
//     transaction.placeholder
//       |> add_tx_input(tx_input)
//       |> add_mint(value) // |> add_mint(value1)
//       |> add_tx_output(tx_output_1)

//   utils1.milestone_mint_create(tx, config_datum, policy_id)
// }

// test create_milestone_output_dont_have_dev_token() fail {
//   let address1 = from_verification_key("abc")

//   expect Some(dev_address1) = prj_datum.developer
//   let tx_input =
//     txn.new_tx_input(campaign_nonce, address1)
//       |> set_datum_of_tx_input(InlineDatum(prj_datum))

//   let tx_output_1 =
//     txn.new_tx_output(dev_address1) // |> add_asset_to_tx_output(value)
//       |> add_asset_to_tx_output(value1)
//       |> set_datum_of_tx_output(InlineDatum(out_prj_datum))
//       |> add_asset_to_tx_output(assets.from_lovelace(21))

//   let tx =
//     transaction.placeholder
//       |> add_tx_input(tx_input)
//       |> add_mint(value)
//       |> add_mint(value1)
//       |> add_tx_output(tx_output_1)

//   utils1.milestone_mint_create(tx, config_datum, policy_id)
// }

// test create_milestone_Holding_diff_address() fail {
//   let config_datum =
//     ConfigDatum {
//       ..config_datum,
//       holding_contract: from_verification_key("abcd"),
//     }

//   // different address
//   let address1 = from_verification_key("abc")

//   // expect Some(dev_address1) = prj_datum.developer
//   let tx_input =
//     txn.new_tx_input(campaign_nonce, address1)
//       |> set_datum_of_tx_input(InlineDatum(prj_datum))

//   let tx_output_1 =
//     txn.new_tx_output(address1)
//       |> add_asset_to_tx_output(value)
//       |> add_asset_to_tx_output(value1)
//       |> set_datum_of_tx_output(InlineDatum(out_prj_datum))
//       |> add_asset_to_tx_output(assets.from_lovelace(21))

//   let tx =
//     transaction.placeholder
//       |> add_tx_input(tx_input)
//       |> add_mint(value)
//       |> add_mint(value1)
//       |> add_tx_output(tx_output_1)

//   utils1.milestone_mint_create(tx, config_datum, policy_id)
// }

// test create_milestone_output_less_ada() fail {
//   let address1 = from_verification_key("abc")

//   expect Some(dev_address1) = prj_datum.developer
//   let tx_input =
//     txn.new_tx_input(campaign_nonce, address1)
//       |> set_datum_of_tx_input(InlineDatum(prj_datum))

//   let tx_output_1 =
//     txn.new_tx_output(dev_address1)
//       |> add_asset_to_tx_output(value)
//       |> add_asset_to_tx_output(value1)
//       |> set_datum_of_tx_output(InlineDatum(out_prj_datum))
//       |> add_asset_to_tx_output(assets.from_lovelace(12))
//   //-- output ADA is less
//   let tx =
//     transaction.placeholder
//       |> add_tx_input(tx_input)
//       |> add_mint(value)
//       |> add_mint(value1)
//       |> add_tx_output(tx_output_1)

//   utils1.milestone_mint_create(tx, config_datum, policy_id)
// }

// test create_milestone_output_No_datum() fail {
//   let address1 = from_verification_key("abc")
//   expect Some(dev_address1) = prj_datum.developer
//   let tx_input =
//     txn.new_tx_input(campaign_nonce, address1)
//       |> set_datum_of_tx_input(InlineDatum(prj_datum))

//   let tx_output_1 =
//     txn.new_tx_output(dev_address1)
//       |> add_asset_to_tx_output(value)
//       |> add_asset_to_tx_output(value1) // NOT passing INLINE datum 
//       // |> set_datum_of_tx_output(InlineDatum(out_prj_datum)) 
//       |> add_asset_to_tx_output(assets.from_lovelace(13))

//   let tx =
//     transaction.placeholder
//       |> add_tx_input(tx_input)
//       |> add_mint(value)
//       |> add_mint(value1)
//       |> add_tx_output(tx_output_1)

//   utils1.milestone_mint_create(tx, config_datum, policy_id)
// }

// test create_milestone_output_diff_datum() fail {
//   let address1 = from_verification_key("abc")

//   expect Some(dev_address1) = prj_datum.developer
//   let tx_input =
//     txn.new_tx_input(campaign_nonce, address1)
//       |> set_datum_of_tx_input(InlineDatum(prj_datum))

//   let tx_output_1 =
//     txn.new_tx_output(dev_address1)
//       |> add_asset_to_tx_output(value)
//       |> add_asset_to_tx_output(value1)
//       |> set_datum_of_tx_output(InlineDatum(prj_datum)) //passing different datum
//       |> add_asset_to_tx_output(assets.from_lovelace(21))

//   let tx =
//     transaction.placeholder
//       |> add_tx_input(tx_input)
//       |> add_mint(value)
//       |> add_mint(value1)
//       |> add_tx_output(tx_output_1)

//   utils1.milestone_mint_create(tx, config_datum, policy_id)
// }
