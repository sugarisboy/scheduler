# frozen_string_literal: true

require 'tty-prompt'
require_relative '../../../api/bean/bean'
require_relative 'question'

# Default description change it
class QuestionWeekDay < Question
  include Bean

  def injections
    @prompt = inject(TTY::Prompt)
  end

  def ask
    choices = [
      { name: 'Понедельник', value: 1 },
      { name: 'Вторник', value: 2 },
      { name: 'Среда', value: 3 },
      { name: 'Четверг', value: 4 },
      { name: 'Пятница', value: 5 },
      { name: 'Суббота', value: 6 }
    ]

    @prompt.select('Укажите день недели:', choices)
  end
end
