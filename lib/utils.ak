use aiken/collection/dict
use aiken/collection/list
use aiken/crypto.{VerificationKeyHash}
use aiken/primitive/bytearray
use cardano/address.{Address, Inline, Script, VerificationKey}
use cardano/assets.{AssetName, Lovelace, PolicyId, Value}
use cardano/transaction.{InlineDatum,
  Input, Output, OutputReference, find_input}
use datum_file as d
use types.{ArbitrationDatum, ConfigDatum, Milestone, ProjectDatum, StakeDatum}

pub fn must_consume_oref(inputs: List<Input>, oref: OutputReference) -> Bool {
  expect Some(_) = find_input(inputs, oref)
  True
}

pub fn address_from_tuple(
  key_hash_tuple: (VerificationKeyHash, VerificationKeyHash),
) {
  let (pkh, skh) = key_hash_tuple
  Address {
    payment_credential: pkh |> VerificationKey,
    stake_credential: if skh == "" {
      None
    } else {
      skh |> VerificationKey |> Inline |> Some
    },
  }
}

pub fn script_address_from_tuple(
  key_hash_tuple: (VerificationKeyHash, VerificationKeyHash),
) {
  let (pkh, skh) = key_hash_tuple
  Address {
    payment_credential: pkh |> Script,
    stake_credential: if skh == "" {
      None
    } else {
      skh |> VerificationKey |> Inline |> Some
    },
  }
}

pub fn find_output_with_policy(outputs: List<Output>, nft: PolicyId) -> Output {
  expect Some(output_utxo) =
    list.find(
      outputs,
      fn(output) -> Bool { list.has(output.value |> assets.policies, nft) },
    )
  output_utxo
}

pub fn find_output_with_nft(outputs: List<Output>, nft: PolicyId) -> Output {
  expect Some(output_utxo) =
    list.find(
      outputs,
      fn(output) -> Bool { list.has(output.value |> assets.policies, nft) },
    )
  output_utxo
}

// refactored
pub fn get_config_datum(
  inputs: List<Input>,
  config_nft: PolicyId,
) -> ConfigDatum {
  expect Some(ref_input) =
    list.find(
      inputs,
      fn(input) { list.has(input.output.value |> assets.policies, config_nft) },
    )
  d.output_to_config_datum(ref_input.output)
}

pub fn find_input_with_policy(inputs: List<Input>, nft: PolicyId) -> Bool {
  list.any(
    inputs,
    fn(input) { list.has(input.output.value |> assets.policies, nft)? },
  )
}

pub fn find_ref_input_with_config_nft(
  inputs: List<Input>,
  nft: PolicyId,
) -> Input {
  expect Some(ref_input) =
    list.find(
      inputs,
      fn(input) { list.has(input.output.value |> assets.policies, nft) },
    )
  ref_input
}

pub fn find_stake_input_by_address(
  inputs: List<Input>,
  address: VerificationKeyHash,
) {
  list.any(
    inputs,
    fn(input) {
      when input.output.address.payment_credential is {
        VerificationKey(vkh) -> vkh == address
        _ -> False
      }
    },
  )
}

pub fn find_output_with_address(
  outputs: List<Output>,
  address: Address,
) -> Output {
  expect Some(some_utxo) =
    list.find(outputs, fn(output) { output.address == address })
  some_utxo
}

pub fn datum_address_update(
  holding_output: Output,
  input_datum: ProjectDatum,
  address: Address,
) -> Bool {
  expect InlineDatum(projectdatum) = holding_output.datum
  expect project_datum: ProjectDatum = projectdatum
  expect Some(project_datum_address) = project_datum.developer
  and {
    project_datum.title == input_datum.title,
    project_datum.client == input_datum.client,
    project_datum.pay == input_datum.pay,
    address_from_tuple(project_datum_address) == address,
  }
}

pub fn must_be_signed_by(
  signatories: List<VerificationKeyHash>,
  signer: VerificationKeyHash,
) -> Bool {
  list.has(signatories, signer)?
}

pub fn must_have_x_token(inputs: List<Input>, policy_id: PolicyId) -> Bool {
  trace @"policyID": policy_id
  let input <- list.any(inputs)
  list.has(input.output.value |> assets.policies, policy_id)?
}

// pub fn find_input_with_policy(inputs: List<Input>, nft: PolicyId) -> Bool {
//   list.any(
//     inputs,
//     fn(input) { (list.has(input.output.value |> assets.policies, nft))? },
//   )

pub fn must_have_token_in_output(
  output: Output,
  token: AssetName,
  policy_id: PolicyId,
) -> Bool {
  trace @"token name": token
  trace @"mingintg tokens": assets.tokens(output.value, policy_id)
  (assets.quantity_of(output.value, policy_id, token) == 1)?
}

pub fn ada_to_script_address(output: Output, pay: Option<Lovelace>) -> Bool {
  when pay is {
    Some(ada) -> ada <= assets.lovelace_of(output.value)
    None -> True
  }
}

pub fn find_output_with_datum(
  outputs: List<Output>,
  datum: ProjectDatum,
) -> Output {
  expect Some(output) =
    list.find(
      outputs,
      fn(output) {
        when output.datum is {
          InlineDatum(datum_data) -> {
            expect output_datum: ProjectDatum = datum_data
            and {
              (output_datum.title == datum.title)?,
              (output_datum.pay == datum.pay)?,
              (output_datum.client == datum.client)?,
              if output_datum.developer == datum.developer {
                and {
                  (output_datum.milestones != datum.milestones)?,
                  (output_datum.current_milestone != datum.current_milestone)?,
                  (output_datum.next_milestone == datum.next_milestone)?,
                }
              } else {
                and {
                  (output_datum.milestones == datum.milestones)?,
                  (output_datum.current_milestone == datum.current_milestone)?,
                  (output_datum.next_milestone == datum.next_milestone)?,
                }
              },
            }
          }

          _ -> False
        }
      },
    )
  output
}

pub fn must_send_to_correct_script(
  output: Output,
  pay: Option<Int>,
  config_datum: ConfigDatum,
) -> Bool {
  when (pay, output.address.payment_credential) is {
    (Some(ada), Script(vkh)) -> and {
        (ada <= assets.lovelace_of(output.value))?,
        // when output.address.payment_credential is {
        // Script(vkh) -> 
        (vkh == config_datum.holding_contract)?,
      }
    // _ -> False
    // },
    (None, Script(vkh)) -> (vkh == config_datum.milestone_contract_address)?
    _ -> {
      trace @"in false"
      False
    }
  }
}

pub fn find_input_with_address(inputs: List<Input>, address: Address) -> Input {
  expect Some(some_utxo) =
    list.find(inputs, fn(input) { input.output.address == address })
  some_utxo
}

pub fn confirm_minting_token_with_milestones(
  mint: Value,
  datum: ProjectDatum,
  policy_id: PolicyId,
) -> Bool {
  let milestones = datum.milestones

  let value = assets.tokens(mint, policy_id)
  //Dict<AssetName, Int>  datatype of value
  and {
    list.all(
      milestones,
      fn(milestone) {
        let token_name =
          datum.title
            |> bytearray.concat("_")
            |> bytearray.concat(milestone.name)
        and {
          dict.has_key(value, bytearray.concat("clt_", token_name)),
          dict.has_key(value, bytearray.concat("dev_", token_name)),
        }
      },
    )?,
    list.all(dict.values(value), fn(qty) { qty == 1 })?,
  }
}

pub fn output_must_have_dev_or_clt_tokens(
  output: Output,
  policy_id: PolicyId,
  datum: ProjectDatum,
  dev_clt: ByteArray,
) -> Bool {
  let value = assets.tokens(output.value, policy_id)
  //Dict<AssetName, Int>  datatype of value
  let token_names = dict.keys(value)
  list.count(
    token_names,
    fn(tokenname) { bytearray.take(tokenname, 4) == dev_clt },
  ) == list.length(datum.milestones)
}

pub fn correct_milestone_ada_to_script(
  output: Output,
  milestone: Option<Milestone>,
) -> Bool {
  when milestone is {
    Some(x) -> (assets.lovelace_of(output.value) >= x.pay)?
    None -> False
  }
}

// pub fn find_nft_with_policy_id(
//   input: Input,
//   policy_id: PolicyId,
// ) -> Dict<AssetName, Int> {
//   assets.tokens(input.output.value, policy_id)
// }

pub fn correct_milestone_updation(
  old_datum: ProjectDatum,
  new_datum: ProjectDatum,
) -> Bool {
  let old_current_milstone_name =
    when old_datum.current_milestone is {
      Some(m) -> m.name
      None -> fail
    }
  let milestone_status =
    list.any(
      new_datum.milestones,
      fn(milestone) {
        if old_current_milstone_name == milestone.name {
          (milestone.status == True)?
        } else {
          False
        }
      },
    )

  and {
    (new_datum.current_milestone == old_datum.next_milestone)?,
    (new_datum.next_milestone == None)?,
    milestone_status?,
  }
}

pub fn datum_for_cancel(datum: ProjectDatum) -> Bool {
  and {
    (datum.current_milestone == None)?,
    (datum.next_milestone == None)?,
    (datum.developer == None)?,
    list.all(
      datum.milestones,
      fn(milestone) {
        if milestone.status == False {
          milestone.pay == 0
        } else {
          True
        }
      },
    )?,
  }
}

// currentMilestone == none &  pay for incomeplete datum == none & developer==none

pub fn must_burn_dev_clt_milestone_token(
  mint: Value,
  policy_id: PolicyId,
  datum: ProjectDatum,
) -> Bool {
  expect [Pair(clt_token_name, 1),
    Pair(dev_token_name, 1)] =
    mint
      |> assets.tokens(policy_id)
      |> dict.to_pairs
  let milestone_name =
    when datum.current_milestone is {
      Some(milestone) -> milestone.name
      None -> fail
    }

  let token_name =
    datum.title
      |> bytearray.concat("_")
      |> bytearray.concat(milestone_name)

  let clt_token_name_var = bytearray.drop(clt_token_name, 4)
  and {
    (clt_token_name_var == bytearray.drop(dev_token_name, 4))?,
    (token_name == clt_token_name_var)?,
  }
}

pub fn milestone_tokens_burn_cancel(
  mint: Value,
  policy_id: PolicyId,
  datum: ProjectDatum,
) -> Bool {
  let incomplete_milestone =
    //2
    list.count(datum.milestones, fn(milestone) { milestone.status == False })

  let burn_count = must_burn_less_than_0(mint, policy_id)
  trace @"count": incomplete_milestone
  trace @"burn": burn_count
  (incomplete_milestone * 2 == burn_count)?
}

pub fn must_burn_less_than_0(mint: Value, policy_id: PolicyId) -> Int {
  let values: Pairs<AssetName, Int> =
    mint
      |> assets.tokens(policy_id)
      |> dict.to_pairs()

  expect list.all(values, fn(Pair(_, amount)) { amount < 0 })?
  list.length(values)
}

pub fn must_burn_dev_clt_token(mint: Value, policy_id: PolicyId) -> Bool {
  expect [Pair(clt_token_name, -1),
    Pair(dev_token_name, -1)] =
    mint
      |> assets.tokens(policy_id)
      |> dict.to_pairs

  and {
    ("dev_" == bytearray.take(dev_token_name, 4))?,
    ("clt_" == bytearray.take(clt_token_name, 4))?,
    (bytearray.drop(dev_token_name, 4) == bytearray.drop(clt_token_name, 4))?,
  }
}

pub fn output_must_have_dev_token(
  output: Output,
  policy_id: PolicyId,
  datum: ProjectDatum,
) -> Bool {
  expect [Pair(dev_token_name, 1)] =
    output.value
      |> assets.tokens(policy_id)
      |> dict.to_pairs

  and {
    bytearray.take(dev_token_name, 4) == "dev_",
    bytearray.drop(dev_token_name, 4) == datum.title,
  }
}

pub fn must_pay_to_developer(output: List<Output>, datum: ProjectDatum) -> Bool {
  expect Some(dev_address) = datum.developer
  let developer_output =
    find_output_with_address(output, address_from_tuple(dev_address))
  must_pay_to_x(developer_output, datum.pay)
}

pub fn must_pay_to_client(output: List<Output>, datum: ProjectDatum) -> Bool {
  let client_output =
    find_output_with_address(output, address_from_tuple(datum.client))
  must_pay_to_x(client_output, datum.pay)?
}

pub fn must_pay_to_x(output: Output, pay: Option<Lovelace>) {
  when pay is {
    Some(ada) -> ada <= assets.lovelace_of(output.value)
    _ -> True
  }
}

pub fn output_must_have_prj_token(
  output: Output,
  policy_id: PolicyId,
  datum: ProjectDatum,
) {
  expect [Pair(assetname, 1)] =
    assets.tokens(output.value, policy_id) |> dict.to_pairs()
  bytearray.drop(assetname, 4) == datum.title
}

pub fn must_send_stake_ada_and_talendro_nft(
  outputs: List<Output>,
  stake_tuple: (VerificationKeyHash, VerificationKeyHash),
  amount: Int,
  policy_id: PolicyId,
  staked_datum: StakeDatum,
) {
  let staked_datum_data: Data = staked_datum
  let stake_address: Address = address_from_tuple(stake_tuple)
  list.any(
    outputs,
    fn(output) {
      when output.datum is {
        InlineDatum(in_datum) ->
          // trace @"vkh": vkh
          // trace @"stkae vkh": stake_vkh
          and {
            (stake_address == output.address)?,
            (staked_datum_data == in_datum)?,
            (assets.lovelace_of(output.value) == amount)?,
            must_have_token_in_output(
              output,
              bytearray.slice(staked_datum.staked_by.1st, 18, 27),
              policy_id,
            )?,
          }
        _ -> False
      }
    },
  )
}

// fn must_send_stake_datum(output: Output) {
//   expect _: StakeDatum = d.output_to_stake_datum(output)
//   True
// }

pub fn is_consuming_staked_ada(
  staked_input: Input,
  datum: ArbitrationDatum,
  redeemer_payto: Int,
) {
  expect Some(dev) = datum.project_datum.developer
  let clt = datum.project_datum.client
  expect InlineDatum(staked_datum) = staked_input.output.datum
  expect StakeDatum { staked_by, .. } = staked_datum
  if redeemer_payto == 0 {
    staked_by == dev
  } else {
    staked_by == clt
  }
}
