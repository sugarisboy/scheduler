# frozen_string_literal: true

# Default description change it
# TODO: Fix validation
AddLectureScheme = Dry::Schema.Params do
  required(:day_week).filled(:integer, gteq?: 1, lteq?: 6)
  required(:num_lecture).filled(:integer, gteq?: 1, lteq?: 6)
  required(:cabinet).filled(:integer)
  required(:subject).filled(:string)
  required(:groups).filled(format?: /^([А-я]+-[0-9]+\s*,\s*)*[А-я]+-[0-9]+$/)
  required(:lector).filled(:string)
end
