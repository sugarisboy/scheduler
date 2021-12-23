# frozen_string_literal: true

FilterLectureScheme = Dry::Schema.Params do
  optional(:cabinet).maybe(:integer, gt?: 0)
  optional(:group).maybe(:string)
  optional(:lector).maybe(:string)
end
