# frozen_string_literal: true

# Default description change it
FindRetakeScheme = Dry::Schema.Params do
  required(:lector).filled(:string)
  required(:groups).filled(format?: /^([А-я]+-[0-9]+\s*,\s*)*[А-я]+-[0-9]+$/)
end
