# frozen_string_literal: true

require_relative '../../api/utils/io_utils'
require_relative '../model/subject'
require_relative '../model/day_scheduler'
require_relative '../model/scheduler'
require_relative '../model/lector'
require_relative '../model/lecture'
require_relative '../../../lib/api/bean/bean'
require_relative '../repository/lector_repository'
require_relative '../repository/scheduler_repository'

# Default description change it
class ModelReader
  include Bean

  WEEK_DAY = 'WEEK_DAY'
  NUM_LECTURE = 'NUM_LECTURE'
  TEACHER = 'TEACHER'
  SUBJECT = 'SUBJECT'
  CABINET = 'CABINET'
  GROUPS = 'GROUPS'

  FILE = 'data.csv'
  SEPARATOR = ';'

  def injections
    @scheduler_repository = inject(SchedulerRepository)
  end

  def load
    csv_data = IOUtils.read_csv(FILE, SEPARATOR)

    csv_data.each do |row|
      week_day = parse_week_day(row)
      num_lecture = parse_num_lecture(row)
      lecture = parse_lecture(row)

      @scheduler_repository.save_lecture(week_day, num_lecture, lecture)
    end
  end

  def parse_lecture(csv_line)
    lector = parse_lector(csv_line)
    subject = parse_subject(csv_line)
    groups = parse_groups(csv_line)
    cabinet = parse_cabinet(csv_line)
    Lecture.new(subject, cabinet, groups, lector)
  end

  def parse_week_day(row)
    row[WEEK_DAY].to_i
  end

  def parse_num_lecture(row)
    row[NUM_LECTURE].to_i
  end

  def parse_lector(csv_line)
    fio = csv_line[TEACHER].strip
    Lector.new(fio)
  end

  def parse_subject(csv_line)
    name = csv_line[SUBJECT].strip
    Subject.new(name)
  end

  def parse_groups(csv_line)
    csv_line[GROUPS].strip.split(',')
  end

  def parse_cabinet(csv_line)
    csv_line[CABINET].strip.to_i
  end
end
