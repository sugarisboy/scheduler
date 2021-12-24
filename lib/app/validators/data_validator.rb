# frozen_string_literal: true

require_relative '../../api/bean/bean'
require_relative 'validator'

# Валидатор данных
class DataValidator < Validator
  include Bean

  def validate_num_lecture(data)
    field = 'Номер лекции'
    not_empty?(data, field)
    between?(1, data, 6, field)
  end

  def validate_day_week(data)
    field = 'День недели'
    not_empty?(data, field)
    between?(1, data, 6, field)
  end
end
