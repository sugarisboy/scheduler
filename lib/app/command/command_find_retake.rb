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
class CommandFindRetake < Command
  include Bean

  def injections
    @prompt = inject(TTY::Prompt)
    @scheduler_service = inject(SchedulerService)
    @retake_service = inject(RetakeService)
    @lector_service = inject(LectorService)
    @group_service = inject(GroupService)
    @printer_service = inject(PrinterService)
  end

  def initialize
    super
    @name = 'Поиск пересдачи'
  end

  def execute
    groups = @group_service.find_groups
    selected_groups = @prompt.multi_select('Выберите список групп: ', groups,
                                           per_page: 15, min: 1)

    lectors = @lector_service.find_lectors
    selected_lector = @prompt.select('Выберите лектора: ', lectors,
                                      per_page: 10)

    result = @retake_service.find_retake_time(selected_lector, selected_groups)

    if result.nil?
      puts 'Время для пересдачи не удалось найти'
    else
      day = @printer_service.format_day(result[:week_day])
      lectures = result[:num_lectures].join(', ')
      cabinet = result[:cabinet]
      puts "Результат: #{day}, #{lectures} пара, #{cabinet} кабинет"
    end
  end
end
