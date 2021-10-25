# frozen_string_literal: true

require_relative '../../api/bean/bean'
require_relative '../../api/utils/io_utils'

# Default description change it
class PrinterService
  include Bean

  TABLE_TEMPLATE = '%<cabinet>5s |%<subject>40s |%<lector>20s |%<groups>s'

  DAY_WEEK_TO_NAME = {
    1 => 'Понедельник',
    2 => 'Вторник',
    3 => 'Среда',
    4 => 'Четверг',
    5 => 'Пятница',
    6 => 'Суббота'
  }.freeze

  def print(scheduler)
    days = scheduler.data
    days.each_pair do |day_week, day_scheduler|
      print_day(day_week, day_scheduler)
    end
  end

  def print_day(day_week, day_scheduler)
    puts IOUtils.as_green("================================= #{DAY_WEEK_TO_NAME[day_week].upcase} =================================")
    numbered_lectures = day_scheduler.data
    numbered_lectures.each_pair do |num_lecture, lectures|
      print_lectures(num_lecture, lectures)
    end
  end

  def print_lectures(num_lecture, lectures)
    return if lectures.empty?

    puts IOUtils.as_aqua("----------------------------------- #{num_lecture} пары ----------------------------------- ")
    msg = format_as_table(
      TABLE_TEMPLATE,
      'каб', 'Дисциплина', 'Преподаватель', 'Группы'
    )
    puts IOUtils.as_aqua(msg)

    lectures.each { |lecture| print_lecture(lecture) }
  end

  def print_lecture(lecture)
    puts format_as_table(
      TABLE_TEMPLATE,
      lecture.cabinet,
      lecture.subject.name,
      lecture.lector.fio,
      lecture.groups.join(',')
    )
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
