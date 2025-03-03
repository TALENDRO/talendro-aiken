// use cardano/address.{from_verification_key}
// use cardano/assets.{from_asset}
// use cardano/transaction.{InlineDatum}
// use mocktail/virgin_key_hash.{mock_policy_id}
// use testcase/constant.{campaign_nonce, config_datum, mil1, policy_id, prj_datum}
// use tx_util/builder/txn.{
//   add_asset_to_tx_output, add_mint, add_tx_input, add_tx_output,
//   set_datum_of_tx_input, set_datum_of_tx_output,
// }
// use types.{ConfigDatum, Milestone, ProjectDatum}
// use utils1

// pub const mil: Milestone = Milestone { ..mil1, status: False, pay: 0 }

// test cancel_milestone_pass() {
//   let prj_datum =
//     ProjectDatum {
//       ..prj_datum,
//       developer: None,
//       milestones: [mil],
//       current_milestone: None,
//       next_milestone: None,
//     }

//   let input_project_datum = from_verification_key("abc")
//   let value = from_asset(mock_policy_id(0), "dev_title_mile", -1)
//   let value1 = from_asset(mock_policy_id(0), "clt_title_mile", -1)
//   let holding_contract_output = config_datum.holding_contract
//   let tx_input =
//     txn.new_tx_input(campaign_nonce, input_project_datum)
//       |> set_datum_of_tx_input(InlineDatum(prj_datum))

//   let tx_output_1 =
//     txn.new_tx_output(holding_contract_output)
//       |> set_datum_of_tx_output(InlineDatum(prj_datum))
//       |> add_asset_to_tx_output(assets.from_lovelace(21))

//   let tx =
//     transaction.placeholder
//       |> add_tx_input(tx_input)
//       |> add_mint(value)
//       |> add_mint(value1)
//       |> add_tx_output(tx_output_1)

//   utils1.milestone_mint_cancel(tx, config_datum, policy_id)
// }

// test cancel_milestone_diff_inputAddr() fail {
//   let prj_datum =
//     ProjectDatum {
//       ..prj_datum,
//       developer: None,
//       milestones: [mil],
//       current_milestone: None,
//       next_milestone: None,
//     }

//   //-----Different input address
//   let input_project_datum = from_verification_key("abcd")
//   let value = from_asset(mock_policy_id(0), "dev_title_mile", -1)
//   let value1 = from_asset(mock_policy_id(0), "clt_title_mile", -1)
//   let holding_contract_output = config_datum.holding_contract
//   let tx_input =
//     txn.new_tx_input(campaign_nonce, input_project_datum)
//       |> set_datum_of_tx_input(InlineDatum(prj_datum))

//   let tx_output_1 =
//     txn.new_tx_output(holding_contract_output)
//       |> set_datum_of_tx_output(InlineDatum(prj_datum))
//       |> add_asset_to_tx_output(assets.from_lovelace(21))

//   let tx =
//     transaction.placeholder
//       |> add_tx_input(tx_input)
//       |> add_mint(value)
//       |> add_mint(value1)
//       |> add_tx_output(tx_output_1)

//   utils1.milestone_mint_cancel(tx, config_datum, policy_id)
// }

// test cancel_milestone_current_milestone_isNotNone() fail {
//   let prj_datum =
//     ProjectDatum {
//       ..prj_datum,
//       developer: None,
//       milestones: [mil],
//       current_milestone: Some(mil1),
//       next_milestone: None,
//     }

//   let input_project_datum = from_verification_key("abc")
//   let value = from_asset(mock_policy_id(0), "dev_title_mile", -1)
//   let value1 = from_asset(mock_policy_id(0), "clt_title_mile", -1)
//   let holding_contract_output = config_datum.holding_contract
//   let tx_input =
//     txn.new_tx_input(campaign_nonce, input_project_datum)
//       |> set_datum_of_tx_input(InlineDatum(prj_datum))

//   let tx_output_1 =
//     txn.new_tx_output(holding_contract_output)
//       |> set_datum_of_tx_output(InlineDatum(prj_datum))
//       |> add_asset_to_tx_output(assets.from_lovelace(21))

//   let tx =
//     transaction.placeholder
//       |> add_tx_input(tx_input)
//       |> add_mint(value)
//       |> add_mint(value1)
//       |> add_tx_output(tx_output_1)

//   utils1.milestone_mint_cancel(tx, config_datum, policy_id)
// }

// ///shoudl be None to Pass
// test cancel_milestone_next_milestone_isNotNone() fail {
//   let prj_datum =
//     ProjectDatum {
//       ..prj_datum,
//       developer: None,
//       milestones: [mil],
//       current_milestone: None,
//       next_milestone: Some(mil),
//     }

//   // should be None to pass
//   let input_project_datum = from_verification_key("abc")
//   let value = from_asset(mock_policy_id(0), "dev_title_mile", -1)
//   let value1 = from_asset(mock_policy_id(0), "clt_title_mile", -1)
//   let holding_contract_output = config_datum.holding_contract
//   let tx_input =
//     txn.new_tx_input(campaign_nonce, input_project_datum)
//       |> set_datum_of_tx_input(InlineDatum(prj_datum))

//   let tx_output_1 =
//     txn.new_tx_output(holding_contract_output)
//       |> set_datum_of_tx_output(InlineDatum(prj_datum))
//       |> add_asset_to_tx_output(assets.from_lovelace(21))

//   let tx =
//     transaction.placeholder
//       |> add_tx_input(tx_input)
//       |> add_mint(value)
//       |> add_mint(value1)
//       |> add_tx_output(tx_output_1)

//   utils1.milestone_mint_cancel(tx, config_datum, policy_id)
// }

// test cancel_milestone_developer_isNotNone() fail {
//   let prj_datum =
//     ProjectDatum {
//       ..prj_datum,
//       developer: Some(from_verification_key("abc")),
//       milestones: // should be None to pass
//       [mil],
//       current_milestone: None,
//       next_milestone: None,
//     }

//   let input_project_datum = from_verification_key("abc")
//   let value = from_asset(mock_policy_id(0), "dev_title_mile", -1)
//   let value1 = from_asset(mock_policy_id(0), "clt_title_mile", -1)
//   let holding_contract_output = config_datum.holding_contract
//   let tx_input =
//     txn.new_tx_input(campaign_nonce, input_project_datum)
//       |> set_datum_of_tx_input(InlineDatum(prj_datum))

//   let tx_output_1 =
//     txn.new_tx_output(holding_contract_output)
//       |> set_datum_of_tx_output(InlineDatum(prj_datum))
//       |> add_asset_to_tx_output(assets.from_lovelace(21))

//   let tx =
//     transaction.placeholder
//       |> add_tx_input(tx_input)
//       |> add_mint(value)
//       |> add_mint(value1)
//       |> add_tx_output(tx_output_1)

//   utils1.milestone_mint_cancel(tx, config_datum, policy_id)
// }

// test cancel_milestone_MilestoneStatus_True() fail {
//   //---------Status should be False to Pass the test
//   let mil4 = Milestone { ..mil, status: True, pay: 0 }

//   let prj_datum =
//     ProjectDatum {
//       ..prj_datum,
//       developer: None,
//       milestones: [mil4],
//       current_milestone: None,
//       next_milestone: None,
//     }

//   let input_project_datum = from_verification_key("abc")
//   let value = from_asset(mock_policy_id(0), "dev_title_mile", -1)
//   let value1 = from_asset(mock_policy_id(0), "clt_title_mile", -1)
//   let holding_contract_output = config_datum.holding_contract
//   let tx_input =
//     txn.new_tx_input(campaign_nonce, input_project_datum)
//       |> set_datum_of_tx_input(InlineDatum(prj_datum))

//   let tx_output_1 =
//     txn.new_tx_output(holding_contract_output)
//       |> set_datum_of_tx_output(InlineDatum(prj_datum))
//       |> add_asset_to_tx_output(assets.from_lovelace(21))

//   let tx =
//     transaction.placeholder
//       |> add_tx_input(tx_input)
//       |> add_mint(value)
//       |> add_mint(value1)
//       |> add_tx_output(tx_output_1)

//   utils1.milestone_mint_cancel(tx, config_datum, policy_id)
// }

// test cancel_milestone_MilestoneStatus_Pay_isNot_Zero() fail {
//   //---------Pay == 0 to Pass the test
//   let mil4 = Milestone { ..mil, status: False, pay: 10 }

//   let prj_datum =
//     ProjectDatum {
//       ..prj_datum,
//       developer: None,
//       milestones: [mil4],
//       current_milestone: None,
//       next_milestone: None,
//     }

//   let input_project_datum = from_verification_key("abc")
//   let value = from_asset(mock_policy_id(0), "dev_title_mile", -1)
//   let value1 = from_asset(mock_policy_id(0), "clt_title_mile", -1)
//   let holding_contract_output = config_datum.holding_contract
//   let tx_input =
//     txn.new_tx_input(campaign_nonce, input_project_datum)
//       |> set_datum_of_tx_input(InlineDatum(prj_datum))

//   let tx_output_1 =
//     txn.new_tx_output(holding_contract_output)
//       |> set_datum_of_tx_output(InlineDatum(prj_datum))
//       |> add_asset_to_tx_output(assets.from_lovelace(21))

//   let tx =
//     transaction.placeholder
//       |> add_tx_input(tx_input)
//       |> add_mint(value)
//       |> add_mint(value1)
//       |> add_tx_output(tx_output_1)

//   utils1.milestone_mint_cancel(tx, config_datum, policy_id)
// }

// test cancel_milestone_2False_milestone_pass() {
//   let mil2: Milestone = Milestone { name: "mile", status: False, pay: 0 }
//   let mil4: Milestone = Milestone { name: "mile", status: True, pay: 10 }
//   let mil3: Milestone = Milestone { name: "mile", status: False, pay: 0 }
//   let prj_datum =
//     ProjectDatum {
//       ..prj_datum,
//       developer: None,
//       milestones: [mil2, mil3, mil4],
//       current_milestone: None,
//       next_milestone: None,
//     }

//   let input_project_datum = from_verification_key("abc")
//   let value = from_asset(policy_id, "dev_title_mile", -1)
//   let value1 = from_asset(policy_id, "clt_title_mile", -1)
//   let value2 = from_asset(policy_id, "dev_abc_mile", -1)
//   let value3 = from_asset(policy_id, "clt_abc_mile", -1)
//   let holding_contract_output = config_datum.holding_contract
//   let tx_input =
//     txn.new_tx_input(campaign_nonce, input_project_datum)
//       |> set_datum_of_tx_input(InlineDatum(prj_datum))

//   let tx_output_1 =
//     txn.new_tx_output(holding_contract_output)
//       |> set_datum_of_tx_output(InlineDatum(prj_datum))
//       |> add_asset_to_tx_output(assets.from_lovelace(21))

//   let tx =
//     transaction.placeholder
//       |> add_tx_input(tx_input)
//       |> add_mint(value)
//       |> add_mint(value1)
//       |> add_mint(value2)
//       |> add_mint(value3)
//       |> add_tx_output(tx_output_1)

//   utils1.milestone_mint_cancel(tx, config_datum, policy_id)
// }

// test cancel_milestone_2False_But_Burn3() fail {
//   let mil2: Milestone = Milestone { name: "mile", status: False, pay: 0 }
//   let mil4: Milestone = Milestone { name: "mile", status: True, pay: 10 }
//   let mil3: Milestone = Milestone { name: "mile", status: False, pay: 0 }
//   let prj_datum =
//     ProjectDatum {
//       ..prj_datum,
//       developer: None,
//       milestones: [mil2, mil3, mil4],
//       current_milestone: None,
//       next_milestone: None,
//     }

//   let input_project_datum = from_verification_key("abc")
//   let value = from_asset(policy_id, "dev_title_mile", -1)
//   let value1 = from_asset(policy_id, "clt_title_mile", -1)
//   let value2 = from_asset(policy_id, "dev_abc_mile", -1)
//   // let value3 = from_asset(policy_id, "clt_abc_mile", -1)
//   let holding_contract_output = config_datum.holding_contract
//   let tx_input =
//     txn.new_tx_input(campaign_nonce, input_project_datum)
//       |> set_datum_of_tx_input(InlineDatum(prj_datum))

//   let tx_output_1 =
//     txn.new_tx_output(holding_contract_output)
//       |> set_datum_of_tx_output(InlineDatum(prj_datum))
//       |> add_asset_to_tx_output(assets.from_lovelace(21))

//   let tx =
//     transaction.placeholder
//       |> add_tx_input(tx_input)
//       |> add_mint(value)
//       |> add_mint(value1)
//       |> add_mint(value2) // |> add_mint(value3) // uncommnet to pass
//       |> add_tx_output(tx_output_1)

//   utils1.milestone_mint_cancel(tx, config_datum, policy_id)
// }

// test cancel_milestone_2False_pay_NOT_0() fail {
//   let mil2: Milestone = Milestone { name: "mile", status: False, pay: 0 }
//   let mil4: Milestone = Milestone { name: "mile", status: True, pay: 10 }
//   let mil3: Milestone = Milestone { name: "mile", status: False, pay: 20 }
//   //pay should be 0, to pass
//   let prj_datum =
//     ProjectDatum {
//       ..prj_datum,
//       developer: None,
//       milestones: [mil2, mil3, mil4],
//       current_milestone: None,
//       next_milestone: None,
//     }

//   let input_project_datum = from_verification_key("abc")
//   let value = from_asset(policy_id, "dev_title_mile", -1)
//   let value1 = from_asset(policy_id, "clt_title_mile", -1)
//   let value2 = from_asset(policy_id, "dev_abc_mile", -1)
//   let value3 = from_asset(policy_id, "clt_abc_mile", -1)
//   let holding_contract_output = config_datum.holding_contract
//   let tx_input =
//     txn.new_tx_input(campaign_nonce, input_project_datum)
//       |> set_datum_of_tx_input(InlineDatum(prj_datum))

//   let tx_output_1 =
//     txn.new_tx_output(holding_contract_output)
//       |> set_datum_of_tx_output(InlineDatum(prj_datum))
//       |> add_asset_to_tx_output(assets.from_lovelace(21))

//   let tx =
//     transaction.placeholder
//       |> add_tx_input(tx_input)
//       |> add_mint(value)
//       |> add_mint(value1)
//       |> add_mint(value2)
//       |> add_mint(value3)
//       |> add_tx_output(tx_output_1)

//   utils1.milestone_mint_cancel(tx, config_datum, policy_id)
// }
