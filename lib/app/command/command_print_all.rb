# frozen_string_literal: true

require_relative 'command'
require_relative '../../api/bean/bean'
require_relative 'question/question_week_day'
require_relative 'question/question_num_lecture'
require_relative 'question/question_create_lecture'
require_relative '../service/printer_service'
require_relative '../service/scheduler_service'

# Command count patients info
class CommandPrintAll < Command
  include Bean

  def injections
    @scheduler_service = inject(SchedulerService)
    @printer_service = inject(PrinterService)
  end

  def initialize
    super
    @name = 'Печать всего расписания'
  end

  def execute
    scheduler = @scheduler_service.find
    @printer_service.print_all(scheduler)
  end
end
