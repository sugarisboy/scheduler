# frozen_string_literal: true

MoveLectureSchema = Dry::Schema.Params do
  required(:old_day_week).filled(:integer, gteq?: 1, lteq?: 6)
  required(:new_day_week).filled(
    :string,
    format?: /^(Понедельник|Вторник|Среда|Четверг|Пятница|Суббота)$/
  )

  required(:old_num_lecture).filled(:integer, gteq?: 1, lteq?: 6)
  required(:new_num_lecture).filled(:integer, gteq?: 1, lteq?: 6)

  required(:old_cabinet).filled(:integer, gt?: 0)
  required(:new_cabinet).filled(:integer, gt?: 0)
end
