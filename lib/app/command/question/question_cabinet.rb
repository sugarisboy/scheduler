# frozen_string_literal: true

require 'tty-prompt'
require_relative 'question'
require_relative '../../../api/bean/bean'
require_relative '../../service/printer_service'
require_relative '../../validators/data_validator'

# Default description change it
class QuestionCabinet < Question
  include Bean

  def injections
    @validator = inject(DataValidator)
  end

  def ask(welcome = 'Введите номер кабинета: ', field = 'Номер кабинета')
    input welcome do |line|
      @validator.not_empty?(line, field)
      @validator.positive?(line, field)
      line
    end
  end
end
