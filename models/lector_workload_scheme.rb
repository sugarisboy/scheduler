# frozen_string_literal: true

# Default description change it
LectorWorkloadScheme = Dry::Schema.Params do
  required(:lector).filled(:string)
end
