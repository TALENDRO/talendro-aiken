// use cardano/address.{from_verification_key}
// use cardano/assets
// use cardano/transaction.{InlineDatum}
// use testcase/constant.{
//   campaign_nonce, config_datum, mil1, mil2, policy_id, prj_datum, value, value1,
// }
// use tx_util/builder/txn.{
//   add_asset_to_tx_output, add_mint, add_tx_input, add_tx_output,
//   set_datum_of_tx_input, set_datum_of_tx_output,
// }
// use types.{ConfigDatum, Milestone, ProjectDatum}
// use utils1

// pub const old_milestone: ProjectDatum = prj_datum

// pub const new_milestone = ProjectDatum { ..prj_datum, next_milestone: None }

// test complete_milestone_pass() {
//   let input_project_datum = from_verification_key("abc")
//   let holding_contract_output = config_datum.holding_contract
//   let tx_input =
//     txn.new_tx_input(campaign_nonce, input_project_datum)
//       |> set_datum_of_tx_input(InlineDatum(old_milestone))

//   let tx_output_1 =
//     txn.new_tx_output(holding_contract_output)
//       |> set_datum_of_tx_output(InlineDatum(new_milestone))
//       |> add_asset_to_tx_output(assets.from_lovelace(21))

//   let tx =
//     transaction.placeholder
//       |> add_tx_input(tx_input)
//       |> add_mint(value)
//       |> add_mint(value1)
//       |> add_tx_output(tx_output_1)

//   utils1.milestone_mint_compelete(tx, config_datum, policy_id)
// }

// test complete_milestone_diff_input_addr() fail {
//   //----------------------different address
//   let input_project_datum = from_verification_key("abcd")

//   //   let address1 = config_datum.holding_contract
//   let output_holding_contract = config_datum.holding_contract
//   let tx_input =
//     txn.new_tx_input(campaign_nonce, input_project_datum)
//       |> set_datum_of_tx_input(InlineDatum(old_milestone))

//   let tx_output_1 =
//     txn.new_tx_output(output_holding_contract)
//       |> set_datum_of_tx_output(InlineDatum(new_milestone))
//       |> add_asset_to_tx_output(assets.from_lovelace(21))

//   let tx =
//     transaction.placeholder
//       |> add_tx_input(tx_input)
//       |> add_mint(value)
//       |> add_mint(value1)
//       |> add_tx_output(tx_output_1)

//   utils1.milestone_mint_compelete(tx, config_datum, policy_id)
// }

// test complete_milestone_diff_output_addr() fail {
//   let config_datum =
//     ConfigDatum {
//       ..config_datum,
//       holding_contract: from_verification_key("abcd"),
//     }

//   //output with diff addres
//   let input_project_datum = from_verification_key("abc")

//   let holding_contract_output = config_datum.holding_contract
//   let tx_input =
//     txn.new_tx_input(campaign_nonce, input_project_datum)
//       |> set_datum_of_tx_input(InlineDatum(old_milestone))

//   let tx_output_1 =
//     txn.new_tx_output(holding_contract_output)
//       |> set_datum_of_tx_output(InlineDatum(new_milestone))
//       |> add_asset_to_tx_output(assets.from_lovelace(21))

//   let tx =
//     transaction.placeholder
//       |> add_tx_input(tx_input)
//       |> add_mint(value)
//       |> add_mint(value1)
//       |> add_tx_output(tx_output_1)

//   utils1.milestone_mint_compelete(tx, config_datum, policy_id)
// }

// test complete_milestone_diff_output_datum() fail {
//   let input_project_datum = from_verification_key("abc")

//   let holding_contract_output = config_datum.holding_contract
//   let tx_input =
//     txn.new_tx_input(campaign_nonce, input_project_datum)
//       |> set_datum_of_tx_input(InlineDatum(old_milestone))

//   let tx_output_1 =
//     txn.new_tx_output(holding_contract_output)
//       |> set_datum_of_tx_output(InlineDatum(config_datum)) //different outptu datum.. it should be new_milestone
//       |> add_asset_to_tx_output(assets.from_lovelace(21))

//   let tx =
//     transaction.placeholder
//       |> add_tx_input(tx_input)
//       |> add_mint(value)
//       |> add_mint(value1)
//       |> add_tx_output(tx_output_1)

//   utils1.milestone_mint_compelete(tx, config_datum, policy_id)
// }

// test complete_milestone_not_passsing_milestone_name() fail {
//   let old_milestone =
//     ProjectDatum {
//       ..prj_datum,
//       current_milestone: Some(Milestone { name: "", status: True, pay: 12 }),
//     }

//   //not passing milestone name
//   let input_project_datum = from_verification_key("abc")

//   let holding_contract_output = config_datum.holding_contract
//   let tx_input =
//     txn.new_tx_input(campaign_nonce, input_project_datum)
//       |> set_datum_of_tx_input(InlineDatum(old_milestone))

//   let tx_output_1 =
//     txn.new_tx_output(holding_contract_output)
//       |> set_datum_of_tx_output(InlineDatum(new_milestone))
//       |> add_asset_to_tx_output(assets.from_lovelace(21))

//   let tx =
//     transaction.placeholder
//       |> add_tx_input(tx_input)
//       |> add_mint(value)
//       |> add_mint(value1)
//       |> add_tx_output(tx_output_1)

//   utils1.milestone_mint_compelete(tx, config_datum, policy_id)
// }

// test complete_milestone_burn_only_dev() fail {
//   let input_project_datum = from_verification_key("abc")
//   let holding_contract_output = config_datum.holding_contract
//   let tx_input =
//     txn.new_tx_input(campaign_nonce, input_project_datum)
//       |> set_datum_of_tx_input(InlineDatum(old_milestone))

//   let tx_output_1 =
//     txn.new_tx_output(holding_contract_output)
//       |> set_datum_of_tx_output(InlineDatum(new_milestone))
//       |> add_asset_to_tx_output(assets.from_lovelace(21))

//   let tx =
//     transaction.placeholder
//       |> add_tx_input(tx_input)
//       |> add_mint(value) //   |> add_mint(value1) //not burning clt_ token
//       |> add_tx_output(tx_output_1)

//   utils1.milestone_mint_compelete(tx, config_datum, policy_id)
// }

// test complete_milestone_burn_only_clt() fail {
//   let input_project_datum = from_verification_key("abc")
//   let holding_contract_output = config_datum.holding_contract
//   let tx_input =
//     txn.new_tx_input(campaign_nonce, input_project_datum)
//       |> set_datum_of_tx_input(InlineDatum(old_milestone))

//   let tx_output_1 =
//     txn.new_tx_output(holding_contract_output)
//       |> set_datum_of_tx_output(InlineDatum(new_milestone))
//       |> add_asset_to_tx_output(assets.from_lovelace(21))

//   let tx =
//     transaction.placeholder
//       |> add_tx_input(tx_input) //   |> add_mint(value) //not burning dev_ token
//       |> add_mint(value1)
//       |> add_tx_output(tx_output_1)

//   utils1.milestone_mint_compelete(tx, config_datum, policy_id)
// }

// test complete_milestone_new_miletsone_name_not_found() fail {
//   //---------hvaing diff milestone name
//   let mil3 = Milestone { ..mil1, name: "mile3" }
//   let new_milestone = ProjectDatum { ..new_milestone, milestones: [mil3] }

//   let input_project_datum = from_verification_key("abc")
//   let holding_contract_output = config_datum.holding_contract
//   let tx_input =
//     txn.new_tx_input(campaign_nonce, input_project_datum)
//       |> set_datum_of_tx_input(InlineDatum(old_milestone))

//   let tx_output_1 =
//     txn.new_tx_output(holding_contract_output)
//       |> set_datum_of_tx_output(InlineDatum(new_milestone))
//       |> add_asset_to_tx_output(assets.from_lovelace(21))

//   let tx =
//     transaction.placeholder
//       |> add_tx_input(tx_input)
//       |> add_mint(value)
//       |> add_mint(value1)
//       |> add_tx_output(tx_output_1)

//   utils1.milestone_mint_compelete(tx, config_datum, policy_id)
// }

// test complete_milestone_new_miletsone_status_false() fail {
//   let mil3 = Milestone { ..mil1, status: False }
//   let new_milestone = ProjectDatum { ..new_milestone, milestones: [mil3] }

//   let input_project_datum = from_verification_key("abc")

//   let holding_contract_output = config_datum.holding_contract
//   let tx_input =
//     txn.new_tx_input(campaign_nonce, input_project_datum)
//       |> set_datum_of_tx_input(InlineDatum(old_milestone))

//   let tx_output_1 =
//     txn.new_tx_output(holding_contract_output)
//       |> set_datum_of_tx_output(InlineDatum(new_milestone))
//       |> add_asset_to_tx_output(assets.from_lovelace(21))

//   let tx =
//     transaction.placeholder
//       |> add_tx_input(tx_input)
//       |> add_mint(value)
//       |> add_mint(value1)
//       |> add_tx_output(tx_output_1)

//   utils1.milestone_mint_compelete(tx, config_datum, policy_id)
// }

// /// new milseont status is False i.e oldmilestone.currentMiletsone.status == newmiletone.miletsone.status
// test complete_milestone_newMilestone_currMil_notEqual_oldMil_nextMile() fail {
//   //name are diff---------------------(new_datum.current_milestone == old_datum.next_milestone)?,
//   let mil3 = Milestone { ..mil1, name: "mile1" }
//   let new_milestone =
//     ProjectDatum {
//       ..new_milestone,
//       milestones: [mil3],
//       current_milestone: Some(mil3),
//     }

//   let input_project_datum = from_verification_key("abc")
//   let holding_contract_output = config_datum.holding_contract
//   let tx_input =
//     txn.new_tx_input(campaign_nonce, input_project_datum)
//       |> set_datum_of_tx_input(InlineDatum(old_milestone))

//   let tx_output_1 =
//     txn.new_tx_output(holding_contract_output)
//       |> set_datum_of_tx_output(InlineDatum(new_milestone))
//       |> add_asset_to_tx_output(assets.from_lovelace(21))

//   let tx =
//     transaction.placeholder
//       |> add_tx_input(tx_input)
//       |> add_mint(value)
//       |> add_mint(value1)
//       |> add_tx_output(tx_output_1)

//   utils1.milestone_mint_compelete(tx, config_datum, policy_id)
// }

// test complete_milestone_newMilestone_nextMile_is_notNone() fail {
//   let new_milestone =
//     ProjectDatum {
//       ..new_milestone,
//       milestones: [mil2],
//       current_milestone: Some(mil2),
//       next_milestone: Some(mil2),
//     }

//   //this is not NONE
//   let input_project_datum = from_verification_key("abc")

//   let holding_contract_output = config_datum.holding_contract
//   let tx_input =
//     txn.new_tx_input(campaign_nonce, input_project_datum)
//       |> set_datum_of_tx_input(InlineDatum(old_milestone))

//   let tx_output_1 =
//     txn.new_tx_output(holding_contract_output)
//       |> set_datum_of_tx_output(InlineDatum(new_milestone))
//       |> add_asset_to_tx_output(assets.from_lovelace(21))

//   let tx =
//     transaction.placeholder
//       |> add_tx_input(tx_input)
//       |> add_mint(value)
//       |> add_mint(value1)
//       |> add_tx_output(tx_output_1)

//   utils1.milestone_mint_compelete(tx, config_datum, policy_id)
// }

// test complete_milestone_output_ADA_less() fail {
//   let input_project_datum = from_verification_key("abc")

//   let holding_contract_output = config_datum.holding_contract
//   let tx_input =
//     txn.new_tx_input(campaign_nonce, input_project_datum)
//       |> set_datum_of_tx_input(InlineDatum(old_milestone))

//   let tx_output_1 =
//     txn.new_tx_output(holding_contract_output)
//       |> set_datum_of_tx_output(InlineDatum(new_milestone))
//       |> add_asset_to_tx_output(assets.from_lovelace(1))

//   let tx =
//     transaction.placeholder
//       |> add_tx_input(tx_input)
//       |> add_mint(value)
//       |> add_mint(value1)
//       |> add_tx_output(tx_output_1)

//   utils1.milestone_mint_compelete(tx, config_datum, policy_id)
// }
