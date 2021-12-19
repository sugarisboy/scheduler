# frozen_string_literal: true

# Default description change it
AddLectureScheme = Dry::Schema.Params do
  required(:day_week).filled(:integer)
  required(:num_lecture).filled(:integer)
  required(:cabinet).filled(:integer)
  required(:subject).filled(:string)
  required(:groups).filled(:string)
  required(:lector).filled(:string)
end
