# frozen_string_literal: true

require_relative '../../api/bean/bean'
require_relative 'validator'

# Default description change it
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

  def validate_subject(data)
    not_empty?(data, 'Название предемета')
  end

  def validate_lector(data)
    not_empty?(data, 'ФИО лектора')
  end

  def validate_cabinet(data)
    positive?(data, 'Номер кабинета')
  end

  def validate_groups(data)
    data.each do |group|
      not_empty?(group, 'Список групп')
    end
  end
end
