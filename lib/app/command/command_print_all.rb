# frozen_string_literal: true

require_relative 'command'
require_relative '../service/printer_service'
require_relative '../service/scheduler_service'
require_relative '../../api/bean/bean'

# Команда печати расписания
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
