# frozen_string_literal: true

require 'tty-prompt'
require_relative '../../../api/bean/bean'
require_relative 'question'

# Default description change it
class QuestionSelectFilter < Question
  include Bean

  def injections
    @prompt = inject(TTY::Prompt)
  end

  def ask
    choices = [
      { name: 'Лектор', value: :lector },
      { name: 'Группа', value: :group },
      { name: 'Кабинет', value: :cabinet },
      { name: 'Дата и время', value: :time }
    ]

    @prompt.select('Выберите аттрибут для фильтрации:', choices)
  end
end
