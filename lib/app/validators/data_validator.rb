# frozen_string_literal: true

require_relative '../../api/bean/bean'
require_relative 'validator'

# Default description change it
class DataValidator < Validator
  include Bean

  def validate_num_lecture(data)
    field = 'num_lecture'
    not_empty?(data, field)
    between?(1, data, 6, field)
  end

  def validate_day_week(data)
    field = 'day_week'
    not_empty?(data, field)
    between?(1, data, 6, field)
  end
end
