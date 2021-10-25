# frozen_string_literal: true

require 'tty-prompt'
require_relative 'question'
require_relative '../../validators/data_validator'
require_relative '../../../api/bean/bean'

# Вопрос о номере кабинета
class QuestionCabinet < Question
  include Bean

  def injections
    @validator = inject(DataValidator)
  end

  def ask(welcome = 'Введите номер кабинета: ')
    input welcome do |line|
      @validator.validate_cabinet(line)
      line.to_i
    end
  end
end
