# frozen_string_literal: true

require 'tty-prompt'
require_relative '../../../api/bean/bean'
require_relative 'question'

# Default description change it
class QuestionNumLecture < Question
  include Bean

  def injections
    @prompt = inject(TTY::Prompt)
  end

  def ask
    choices = [
      { name: 'Первая', value: 1 },
      { name: 'Вторая', value: 2 },
      { name: 'Третья', value: 3 },
      { name: 'Четвертая', value: 4 },
      { name: 'Пятая', value: 5 },
      { name: 'Шестая', value: 6 }
    ]

    @prompt.select('Укажите номер лекции:', choices)
  end
end
