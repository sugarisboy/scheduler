# frozen_string_literal: true

require_relative 'app/reader/model_reader'
require_relative 'api/context'
require_relative 'api/application'
require_relative 'app/model/scheduler'
require_relative 'app/service/printer_service'

# Main class for scheduler app
class SchedulerApp < Application
  def injections
    @reader = @context.inject(ModelReader)
    @scheduler = @context.inject(Scheduler)
  end

  def load
    @reader.load
  end

  def start
    puts 'loading scheduler:'
    @context.inject(PrinterService).print(@scheduler)
  end
end
