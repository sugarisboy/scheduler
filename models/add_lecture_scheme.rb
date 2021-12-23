# frozen_string_literal: true

AddLectureScheme = Dry::Schema.Params do
  required(:day_week).filled(
    :string,
    format?: /^(Понедельник|Вторник|Среда|Четверг|Пятница|Суббота)$/
  )
  required(:num_lecture).filled(:integer, gteq?: 1, lteq?: 6)
  required(:cabinet).filled(:integer, gt?: 0)
  required(:subject).filled(:string)
  required(:groups).filled(format?: /^([А-я]+-[0-9]+\s*,\s*)*[А-я]+-[0-9]+$/)
  required(:lector).filled(:string)
end
