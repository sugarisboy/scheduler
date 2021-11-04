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
require_relative '../validators/data_validator'

# Команда для частичной печать по критерию
class CommandPrintCriteria < Command
  include Bean

  def injections
    @service = inject(SchedulerService)
    @printer = inject(PrinterService)
    @validator = inject(DataValidator)
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
    when :lector
      filtered_scheduler = select_by_lector
    when :group
      filtered_scheduler = select_by_group
    when :cabinet
      filtered_scheduler = select_by_cabinet
    when :time
      filtered_scheduler = select_by_time
      # else
      #   raise BusinessException, "Не найдено значение фильтра #{filter}"
    end

    @printer.print_all(filtered_scheduler)
  end

  def select_by_group
    group = @question_line.ask('Введите название группы:', 'Имя группы')

    @service.find_by_group(group)
  end

  def select_by_cabinet
    cabinet = @question_line.ask('Введите номер кабинета:', 'Имя группы')
    @service.find_by_cabinet(cabinet.to_i)
  end

  def select_by_lector
    lector = @question_line.ask('Введите ФИО лектора:', 'ФИО лектора')
    @service.find_by_lector(lector)
  end

  def select_by_time
    week_day = @question_week_day.ask
    num_lecture = @question_num_lecture.ask
    @service.lectures_by_time(week_day, num_lecture)
  end
end
