// use cardano/address.{Address, Script}
// use cardano/assets.{from_asset}
// use cardano/transaction.{InlineDatum}
// use mocktail/virgin_key_hash.{mock_policy_id}
// use testcase/constant.{campaign_nonce, config_datum, policy_id, prj_datum}
// use tx_util/builder/txn.{
//   add_asset_to_tx_output, add_mint, add_tx_input, add_tx_output,
//   set_datum_of_tx_output, with_asset_of_tx_input,
// }
// use types.{ConfigDatum, ProjectDatum}
// use utils1

// pub const config_datum =
//   ConfigDatum {
//     ..config_datum,
//     milestone_contract_address: Address(Script("abc"), None),
//   }

// test cancel_milestone_spend_Developer_NONE_pass() {
//   let prj_datum = ProjectDatum { ..prj_datum, developer: None }
//   let address1 = prj_datum.client
//   let value = from_asset(policy_id, "dev_title_mile", -1)
//   let value1 = from_asset(policy_id, "clt_title_mile", -1)

//   let tx_input =
//     txn.new_tx_input(campaign_nonce, address1)
//       |> with_asset_of_tx_input(value)
//       |> with_asset_of_tx_input(value1)

//   let tx_output_1 =
//     txn.new_tx_output(address1)
//       |> add_asset_to_tx_output(value)
//       |> add_asset_to_tx_output(value1)

//   let tx =
//     transaction.placeholder
//       |> add_tx_input(tx_input)
//       |> add_mint(value)
//       |> add_mint(value1)
//       |> add_tx_output(tx_output_1)

//   utils1.milestone_spend_cancel(tx, prj_datum, config_datum, policy_id)
// }

// test cancel_milestone_spend_Developer_NONE_only_CltToken() fail {
//   let prj_datum = ProjectDatum { ..prj_datum, developer: None }

//   let address1 = prj_datum.client
//   let value = from_asset(policy_id, "dev_title_mile", -1)

//   // let value1 = from_asset(policy_id, "clt_title_mile", -1) -- not passing clt token
//   let tx_input = txn.new_tx_input(campaign_nonce, address1)

//   let tx_output_1 =
//     txn.new_tx_output(address1)
//       |> add_asset_to_tx_output(value)

//   let tx =
//     transaction.placeholder
//       |> add_tx_input(tx_input)
//       |> add_mint(value) // |> add_mint(value1)
//       |> add_tx_output(tx_output_1)

//   utils1.milestone_spend_cancel(tx, prj_datum, config_datum, policy_id)
// }

// test cancel_milestone_spend_Developer_NONE_only_DevToken() fail {
//   let prj_datum = ProjectDatum { ..prj_datum, developer: None }

//   let address1 = prj_datum.client
//   // let value = from_asset(policy_id, "dev_title_mile", -1)  -- not passing dev token
//   let value1 = from_asset(policy_id, "clt_title_mile", -1)

//   let tx_input = txn.new_tx_input(campaign_nonce, address1)

//   let tx_output_1 =
//     txn.new_tx_output(address1)
//       |> add_asset_to_tx_output(value1)

//   let tx =
//     transaction.placeholder
//       |> add_tx_input(tx_input) // |> add_mint(value)
//       |> add_mint(value1)
//       |> add_tx_output(tx_output_1)

//   utils1.milestone_spend_cancel(tx, prj_datum, config_datum, policy_id)
// }

// ///---------------------------------Developer is Some---------
// test cancel_milestone_spend_Developer_pass() {
//   let out_prj_datum = ProjectDatum { ..prj_datum, developer: None }

//   //Some(from_verification_key("abc")),
//   let address1 = prj_datum.client
//   let value = from_asset(policy_id, "dev_title_mile", -1)

//   let script_addr = config_datum.milestone_contract_address

//   let tx_input =
//     txn.new_tx_input(campaign_nonce, address1)
//       |> with_asset_of_tx_input(value)

//   let tx_output_1 =
//     txn.new_tx_output(script_addr)
//       |> add_asset_to_tx_output(value)
//       |> set_datum_of_tx_output(InlineDatum(out_prj_datum))

//   let tx =
//     transaction.placeholder
//       |> add_tx_input(tx_input)
//       |> add_tx_output(tx_output_1)

//   utils1.milestone_spend_cancel(tx, prj_datum, config_datum, policy_id)
// }

// test cancel_milestone_spend_Developer_pasiing_diff_Output_addr() fail {
//   let out_prj_datum = ProjectDatum { ..prj_datum, developer: None }

//   //Some(from_verification_key("abc")),
//   let address1 = prj_datum.client
//   let value = from_asset(policy_id, "dev_title_mile", 1)

//   // let script_addr = config_datum.milestone_contract_address
//   let tx_input =
//     txn.new_tx_input(campaign_nonce, address1)
//       |> with_asset_of_tx_input(value)

//   let tx_output_1 =
//     txn.new_tx_output(address1) //passing differnet address (script_addr is needed to pass)
//       |> add_asset_to_tx_output(value)
//       |> set_datum_of_tx_output(InlineDatum(out_prj_datum))

//   let tx =
//     transaction.placeholder
//       |> add_tx_input(tx_input)
//       |> add_tx_output(tx_output_1)

//   utils1.milestone_spend_cancel(tx, prj_datum, config_datum, policy_id)
// }

// test cancel_milestone_spend_Developer_passing_diff_OutputDatum() fail {
//   let address1 = prj_datum.client
//   let value = from_asset(policy_id, "dev_title_mile", 1)

//   let script_addr = config_datum.milestone_contract_address

//   let tx_input =
//     txn.new_tx_input(campaign_nonce, address1)
//       |> with_asset_of_tx_input(value)

//   let tx_output_1 =
//     txn.new_tx_output(script_addr)
//       |> add_asset_to_tx_output(value)
//       |> set_datum_of_tx_output(InlineDatum(config_datum))

//   //pasing different datum
//   let tx =
//     transaction.placeholder
//       |> add_tx_input(tx_input)
//       |> add_tx_output(tx_output_1)

//   utils1.milestone_spend_cancel(tx, prj_datum, config_datum, policy_id)
// }

// test cancel_milestone_spend_Developer_passing_Diff_token() fail {
//   let out_prj_datum = ProjectDatum { ..prj_datum, developer: None }

//   //Some(from_verification_key("abc")),
//   let address1 = prj_datum.client
//   let value = from_asset(policy_id, "abc_title_mile", 1)
//   //---passing different token
//   let script_addr = config_datum.milestone_contract_address

//   let tx_input =
//     txn.new_tx_input(campaign_nonce, address1)
//       |> with_asset_of_tx_input(value)

//   let tx_output_1 =
//     txn.new_tx_output(script_addr)
//       |> add_asset_to_tx_output(value)
//       |> set_datum_of_tx_output(InlineDatum(out_prj_datum))

//   let tx =
//     transaction.placeholder
//       |> add_tx_input(tx_input)
//       |> add_tx_output(tx_output_1)

//   utils1.milestone_spend_cancel(tx, prj_datum, config_datum, policy_id)
// }

// test cancel_milestone_spend_Developer_passing_diff_PId() fail {
//   let out_prj_datum = ProjectDatum { ..prj_datum, developer: None }

//   //Some(from_verification_key("abc")),
//   let address1 = prj_datum.client
//   let value = from_asset(mock_policy_id(2), "dev_title_mile", 1)

//   //passing different policy_id
//   let script_addr = config_datum.milestone_contract_address

//   let tx_input =
//     txn.new_tx_input(campaign_nonce, address1)
//       |> with_asset_of_tx_input(value)

//   let tx_output_1 =
//     txn.new_tx_output(script_addr)
//       |> add_asset_to_tx_output(value)
//       |> set_datum_of_tx_output(InlineDatum(out_prj_datum))

//   let tx =
//     transaction.placeholder
//       |> add_tx_input(tx_input)
//       |> add_tx_output(tx_output_1)

//   utils1.milestone_spend_cancel(tx, prj_datum, config_datum, policy_id)
// }
