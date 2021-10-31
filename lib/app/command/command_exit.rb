# frozen_string_literal: true

require_relative 'command'
require_relative 'question/question_week_day'
require_relative 'question/question_num_lecture'
require_relative 'question/question_create_lecture'
require_relative '../service/printer_service'
require_relative '../../api/bean/bean'

# Комманда завершения работы
class CommandExit < Command
  include Bean

  def initialize
    super
    @name = 'Завершить работу'
  end

  def end_session?
    true
  end
end
