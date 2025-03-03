// use cardano/assets.{from_asset}
// use cardano/transaction
// use mocktail/virgin_key_hash.{mock_policy_id}
// use testcase/constant.{campaign_nonce, config_datum, policy_id, prj_datum}
// use tx_util/builder/txn.{add_tx_input, add_tx_output, with_asset_of_tx_input}
// use types.{ConfigDatum, ProjectDatum}
// use utils1

// test create_milestone_spend_pass() {
//   let address1 = prj_datum.client
//   expect Some(dev_address1) = prj_datum.developer

//   let tx_input =
//     txn.new_tx_input(campaign_nonce, address1)
//       |> with_asset_of_tx_input(from_asset(policy_id, "dev_title_mile", 1))
//       |> with_asset_of_tx_input(
//           from_asset(config_datum.talendrouser_nft, "dev", 1),
//         )

//   let tx_output_1 = txn.new_tx_output(dev_address1)

//   let tx =
//     transaction.placeholder
//       |> add_tx_input(tx_input)
//       |> add_tx_output(tx_output_1)

//   utils1.milestone_spend_create(tx, policy_id, config_datum)
// }

// test create_milestone_spend_diff_PID() fail {
//   let policy_id1 = mock_policy_id(9)

//   let address1 = prj_datum.client
//   //   let value = from_asset(policy_id, "dev_dev_mile", 1)
//   expect Some(dev_address1) = prj_datum.developer

//   let tx_input =
//     txn.new_tx_input(campaign_nonce, address1)
//       |> with_asset_of_tx_input(from_asset(mock_policy_id(5), "dev_dev_mile", 1)) //-------------------------passing diff PID (it should be (9) to pass)
//     |> with_asset_of_tx_input(from_asset(config_datum.talendrouser_nft, "dev", 1))

//   let tx_output_1 = txn.new_tx_output(dev_address1)

//   let tx =
//     transaction.placeholder
//       |> add_tx_input(tx_input)
//       |> add_tx_output(tx_output_1)

//   utils1.milestone_spend_create(tx, policy_id1, config_datum)
// }

// test create_milestone_spend_diff_token_PID()  fail{
//   let address1 = prj_datum.client
//   expect Some(dev_address1) = prj_datum.developer

//   let tx_input =
//     txn.new_tx_input(campaign_nonce, address1)
//       |> with_asset_of_tx_input(from_asset(mock_policy_id(2), "dev_dev_mile", 1))
//       |> with_asset_of_tx_input(from_asset(mock_policy_id(9), "dev", 1))
//   //-----------passing a differnt PID
//   let tx_output_1 = txn.new_tx_output(dev_address1)

//   let tx =
//     transaction.placeholder
//       |> add_tx_input(tx_input)
//       |> add_tx_output(tx_output_1)

//   utils1.milestone_spend_create(tx, policy_id, config_datum)
// }
