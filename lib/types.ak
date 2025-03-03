use aiken/crypto.{VerificationKeyHash}
use cardano/assets.{Lovelace, PolicyId}

pub type ProjectDatum {
  title: ByteArray,
  pay: Option<Lovelace>,
  developer: Option<AddressSchema>,
  client: AddressSchema,
  milestones: List<Milestone>,
  current_milestone: Option<Milestone>,
  next_milestone: Option<Milestone>,
}

pub type Milestone {
  name: ByteArray,
  status: Bool,
  pay: Lovelace,
}

pub type AddressSchema =
  (VerificationKeyHash, VerificationKeyHash)

pub type ConfigDatum {
  identification_nft: PolicyId,
  milestone_contract_policy: PolicyId,
  milestone_contract_address: VerificationKeyHash,
  holding_contract: VerificationKeyHash,
  projectinit_contract: VerificationKeyHash,
  arbitrator_nft: PolicyId,
  arbitrator_contract: VerificationKeyHash,
  talendrouser_nft: PolicyId,
  stake_vkh: AddressSchema,
  stake_amount: Int,
}

// the contract that holds the assets
pub type ArbitrationDatum {
  project_datum: ProjectDatum,
  pow: ByteArray,
}

pub type StakeDatum {
  staked_by: AddressSchema,
  staked_amount: Int,
}

// staked_on: 
// last_claim:

// pub type MilestoneRedeemer {
//   Create
//   Complete
//   Cancel
// }

pub type ProjectRedeemer {
  Create
  Complete
  Cancel
  Arbitrator
}

pub type ArbitrationRedeemer {
  payto: Int,
}
