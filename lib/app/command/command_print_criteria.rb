# frozen_string_literal: true

require_relative 'command'
require_relative '../../api/bean/bean'
require_relative 'question/question_week_day'
require_relative 'question/question_num_lecture'
require_relative 'question/question_create_lecture'
require_relative 'question/question_select_filter'
require_relative 'question/question_not_blank_string'
require_relative 'question/question_cabinet'
require_relative '../service/printer_service'
require_relative '../service/scheduler_service'

# Command count patients info
class CommandPrintCriteria < Command
  include Bean

  def injections
    @service = inject(SchedulerService)
    @printer = inject(PrinterService)
    @question_num_lecture = inject(QuestionNumLecture)
    @question_week_day = inject(QuestionWeekDay)
    @question_select_filter = inject(QuestionSelectFilter)
    @question_line = inject(QuestionNotBlankString)
    @question_cabinet = inject(QuestionCabinet)
  end

  def initialize
    super
    @name = 'Печать раписания по критерию'
  end

  def execute
    filter = @question_select_filter.ask

    case filter
    when :group
      group = @question_line.ask('Введите название группы:', 'Имя группы')
      filtered_scheduler = @service.find_by_group(group)
    when :cabinet
      cabinet = @question_line.ask('Введите номер кабинета:', 'Имя группы')
      filtered_scheduler = @service.find_by_cabinet(cabinet.to_i)
    when :lector
      lector = @question_line.ask('Введите ФИО лектора:', 'ФИО лектора')
      filtered_scheduler = @service.find_by_lector(lector)
    when :time
      week_day = @question_week_day.ask
      num_lecture = @question_num_lecture.ask
      filtered_scheduler = @service.lectures_by_time(week_day, num_lecture)
    else
      raise BusinessException, "Не найдено значение фильтра #{filter}"
    end

    @printer.print_all(filtered_scheduler)
  end
end
