use cardano/transaction.{InlineDatum, Input, Output}
use types.{ArbitrationDatum, ConfigDatum, ProjectDatum, StakeDatum}

pub fn output_to_project_datum(output: Output) -> ProjectDatum {
  expect InlineDatum(data) = output.datum
  expect datum: ProjectDatum = data
  datum
}

pub fn input_to_project_datum(input: Input) -> ProjectDatum {
  expect InlineDatum(data) = input.output.datum
  expect datum: ProjectDatum = data
  datum
}

pub fn output_to_config_datum(output: Output) -> ConfigDatum {
  expect InlineDatum(data) = output.datum
  expect datum: ConfigDatum = data
  datum
}

pub fn input_to_config_datum(input: Input) -> ConfigDatum {
  expect InlineDatum(data) = input.output.datum
  expect datum: ConfigDatum = data
  datum
}

pub fn output_to_arbitration_datum(output: Output) -> ArbitrationDatum {
  expect InlineDatum(data) = output.datum
  expect datum: ArbitrationDatum = data
  datum
}

pub fn output_to_stake_datum(output: Output) -> StakeDatum {
  expect InlineDatum(data) = output.datum
  expect datum: StakeDatum = data
  datum
}
