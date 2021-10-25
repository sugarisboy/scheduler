# frozen_string_literal: true

require_relative '../model/day_scheduler'
require_relative '../model/scheduler'
require_relative '../model/lecture'
require_relative '../service/scheduler_service'
require_relative '../config/env_config'
require_relative '../../api/utils/io_utils'
require_relative '../../../lib/api/bean/bean'

# Класс для чтения данных из файла
class ModelFileConverter
  include Bean

  # Название колонок в файле
  WEEK_DAY = 'WEEK_DAY'
  NUM_LECTURE = 'NUM_LECTURE'
  TEACHER = 'TEACHER'
  SUBJECT = 'SUBJECT'
  CABINET = 'CABINET'
  GROUPS = 'GROUPS'

  # Параметры файла
  SEPARATOR = ';'

  def injections
    @envs = inject(EnvConfig)
    @service = inject(SchedulerService)
  end

  # Запуск загрузки данных из файла
  def read
    csv_data = IOUtils.read_csv(local_path, SEPARATOR)

    csv_data.each do |row|
      week_day = parse_week_day(row)
      num_lecture = parse_num_lecture(row)
      lecture = parse_lecture(row)

      @service.add_lecture(week_day, num_lecture, lecture)
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
    csv_line[TEACHER].strip
  end

  def parse_subject(csv_line)
    csv_line[SUBJECT].strip
  end

  def parse_groups(csv_line)
    csv_line[GROUPS].strip.split(',')
  end

  def parse_cabinet(csv_line)
    csv_line[CABINET].strip.to_i
  end

  def convert_to_csv(scheduler)
    header = [WEEK_DAY, NUM_LECTURE, TEACHER, SUBJECT, CABINET, GROUPS]
    converted = scheduler.map do |lecture, day, num|
      groups = lecture.groups.join(',')
      [day, num, lecture.lector, lecture.subject, lecture.cabinet, groups]
    end
    converted.unshift(header)
    converted
  end

  def write(scheduler)
    data = convert_to_csv(scheduler)
    IOUtils.write_csv(local_path, SEPARATOR, data)
  end

  private

  def local_path
    "#{@envs.data_dir}/#{@envs.file}"
  end
end
