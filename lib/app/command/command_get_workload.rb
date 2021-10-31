# frozen_string_literal: true

require 'tty-prompt'
require_relative 'command'
require_relative '../../api/bean/bean'
require_relative '../service/group_service'
require_relative '../service/retake_service'
require_relative '../service/scheduler_service'
require_relative '../service/lector_service'
require_relative '../service/printer_service'

# Command count patients info
class CommandGetWorkload < Command
  include Bean

  def injections
    @prompt = inject(TTY::Prompt)
    @scheduler_service = inject(SchedulerService)
    @retake_service = inject(RetakeService)
    @lector_service = inject(LectorService)
    @printer_service = inject(PrinterService)
  end

  def initialize
    super
    @name = 'Узнать загрузку лектора'
  end

  def execute
    lectors = @lector_service.find_lectors
    selected_lector = @prompt.select('Выберите лектора: ', lectors,
                                     per_page: 10)

    count = @lector_service.find_lectures(selected_lector).count
    subject = @lector_service.find_subjects(selected_lector)
    groups = @lector_service.find_groups(selected_lector)

    puts "Количество лекций в неделю: #{count}"
    puts "Список связанных дисциплин: #{subject.join(', ')}"
    puts "Список связанных групп: #{groups.join(', ')}"
  end
end
