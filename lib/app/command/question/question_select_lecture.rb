# frozen_string_literal: true

require 'tty-prompt'
require_relative 'question'
require_relative '../../../api/bean/bean'
require_relative '../../service/printer_service'

# Вопрос о выборе лекции
class QuestionSelectLecture < Question
  include Bean

  def injections
    @prompt = inject(TTY::Prompt)
    @printer = inject(PrinterService)
  end

  def ask(lectures)
    choices = lectures.map do |lecture, _, _|
      {
        name: @printer.format_lecture(lecture),
        value: lecture
      }
    end

    @prompt.select('Выберите лекцию: ', choices)
  end
end
