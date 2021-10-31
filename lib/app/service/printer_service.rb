# frozen_string_literal: true

require_relative '../../api/bean/bean'
require_relative '../../api/utils/io_utils'
require_relative '../service/scheduler_service'

# Сервис для форматирования и печати сущностей
class PrinterService
  include Bean

  def injections
    @service = inject(SchedulerService)
  end

  TABLE_TEMPLATE = '%<cabinet>5s |%<subject>40s |%<lector>20s |%<groups>s'

  SEPARATOR = '-----------------------------------'
  BOLD_SEPARATOR = '================================='

  DAY_WEEK_TO_NAME = {
    1 => 'Понедельник',
    2 => 'Вторник',
    3 => 'Среда',
    4 => 'Четверг',
    5 => 'Пятница',
    6 => 'Суббота'
  }.freeze

  def print_all(scheduler = @repository.scheduler)
    days = scheduler.data
    days.each_pair do |day_week, day_scheduler|
      print_day(day_week, day_scheduler)
    end
  end

  def print_day(week_day, day_scheduler)
    msg = "#{BOLD_SEPARATOR} #{DAY_WEEK_TO_NAME[week_day]} #{BOLD_SEPARATOR}"
    puts IOUtils.as_green(msg)
    day_scheduler.data.each do |num_lecture, lectures|
      print_lectures(num_lecture, lectures)
    end
  end

  def print_lectures(num_lecture, lectures)
    return if lectures.count.zero?

    lectures = lectures.sort_by(&:cabinet)

    msg = "#{SEPARATOR} #{num_lecture} пары #{SEPARATOR}"
    puts IOUtils.as_aqua(msg)
    msg = format_as_table(
      TABLE_TEMPLATE,
      'каб', 'Дисциплина', 'Преподаватель', 'Группы'
    )
    puts IOUtils.as_aqua(msg)

    lectures.each { |lecture| print_lecture(lecture) }
  end

  def print_lecture(lecture)
    puts format_lecture(lecture)
  end

  def format_lecture(lecture)
    format_as_table(
      TABLE_TEMPLATE,
      lecture.cabinet,
      lecture.subject,
      lecture.lector,
      lecture.groups.join(',')
    )
  end

  def format_day(day)
    DAY_WEEK_TO_NAME[day]
  end

  def format_as_table(template, cabinet, subject, lector, groups)
    data = {
      cabinet: cabinet,
      subject: subject,
      lector: lector,
      groups: groups
    }
    format(template, data)
  end
end
