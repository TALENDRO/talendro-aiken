// use cardano/address.{from_verification_key}
// use cardano/assets.{from_asset}
// // use cardano/transaction
// use mocktail.{mock_utxo_ref}
// use mocktail/virgin_key_hash.{mock_policy_id}
// // use tx_util/builder/txn.{add_tx_input, add_tx_output, with_asset_of_tx_input}
// use types.{ConfigDatum, Milestone, ProjectDatum}

// // use utils1

// pub const campaign_nonce = mock_utxo_ref(0, 0)

// pub const prj = ProjectDatum

// pub const policy_id = mock_policy_id(0)

// pub const mil1: Milestone = Milestone { name: "mile", status: True, pay: 12 }

// pub const mil2: Milestone = Milestone { name: "mile", status: True, pay: 13 }

// pub const prj_datum =
//   ProjectDatum {
//     title: "title",
//     pay: Some(10),
//     developer: Some(from_verification_key("abc")),
//     client: from_verification_key("abc"),
//     milestones: [mil1],
//     current_milestone: Some(mil1),
//     next_milestone: Some(mil1),
//   }

// pub const config_datum =
//   ConfigDatum {
//     identification_nft: mock_policy_id(0),
//     milestone_contract_policy: mock_policy_id(0),
//     milestone_contract_address: from_verification_key("abc"),
//     holding_contract: from_verification_key("abc"),
//     projectinit_contract: from_verification_key("abc"),
//     arbitrator_nft: mock_policy_id(0),
//     arbitrator_contract: from_verification_key("abc"),
//     talendrouser_nft: mock_policy_id(0),
//   }

// pub const value = from_asset(mock_policy_id(0), "dev_title_mile", 1)

// pub const value1 = from_asset(mock_policy_id(0), "clt_title_mile", 1)
// //   let mil4 = Milestone { ..mil, status: True, pay: 0 }
