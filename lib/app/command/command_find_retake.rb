# frozen_string_literal: true

require 'tty-prompt'
require_relative 'command'
require_relative '../service/group_service'
require_relative '../service/retake_service'
require_relative '../service/lector_service'
require_relative '../service/printer_service'
require_relative '../../api/bean/bean'

# Команда для поиска времени и места пересдачи
class CommandFindRetake < Command
  include Bean

  def injections
    @prompt = inject(TTY::Prompt)
    @group_service = inject(GroupService)
    @lector_service = inject(LectorService)
    @retake_service = inject(RetakeService)
    @printer_service = inject(PrinterService)
  end

  def initialize
    super
    @name = 'Поиск пересдачи'
  end

  def execute
    groups = @group_service.find_groups
    selected_groups = @prompt.multi_select(
      'Выберите список групп: ', groups, per_page: 15, min: 1
    )

    lectors = @lector_service.find_lectors
    selected_lector = @prompt.select(
      'Выберите лектора: ', lectors, per_page: 10
    )

    result = @retake_service.find_retake_time(selected_lector, selected_groups)
    if result.nil?
      print_failed
    else
      print_success(result)
    end
  end

  def print_success(result)
    cabinet = result[:cabinet]
    day = @printer_service.format_day(result[:week_day])
    lectures = result[:num_lectures].join(', ')
    puts "Результат: #{day}, #{lectures} пара, #{cabinet} кабинет"
  end

  def print_failed
    puts 'Время для пересдачи не удалось найти'
  end
end
