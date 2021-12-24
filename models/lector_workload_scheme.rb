# frozen_string_literal: true

LectorWorkloadScheme = Dry::Schema.Params do
  required(:lector).maybe(:string)
end
