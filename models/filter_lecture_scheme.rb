# frozen_string_literal: true

# Default description change it
FilterLectureScheme = Dry::Schema.Params do
  optional(:cabinet).maybe(:integer, gt?: 0)
  optional(:group).maybe(:string)
  optional(:lector).maybe(:string)
end
