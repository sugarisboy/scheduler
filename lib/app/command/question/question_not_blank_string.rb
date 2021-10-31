# frozen_string_literal: true

require 'tty-prompt'
require_relative 'question'
require_relative '../../service/printer_service'
require_relative '../../validators/data_validator'
require_relative '../../../api/bean/bean'

# Вопрос о вводе непустой строки
class QuestionNotBlankString < Question
  include Bean

  def injections
    @prompt = inject(TTY::Prompt)
    @printer = inject(PrinterService)
    @validator = inject(DataValidator)
  end

  def ask(welcome = 'Введите значение: ', field = 'Строка')
    input welcome do |line|
      @validator.not_empty?(line, field)
      line
    end
  end
end
