# frozen_string_literal: true

require_relative '../model/ref_data'
require_relative '../service/group_service'
require_relative '../service/retake_service'
require_relative '../service/lector_service'
require_relative '../service/updater_service'
require_relative '../service/scheduler_service'
require_relative '../converter/model_file_converter'
require_relative '../../api/bean/bean'
require_relative '../../api/exception/business_exception'

# Преобразует данные с фронта в данные для бека
class AggregatorWrapper
  include Bean

  def injections
    @retake_service = inject(RetakeService)
    @scheduler_service = inject(SchedulerService)
    @updater_service = inject(UpdaterService)
    @lector_service = inject(LectorService)
    @group_service = inject(GroupService)
    @converter = inject(ModelFileConverter)
  end

  def search_retakes(raw_lector, raw_groups)
    @retake_service
      .find_retake_time(raw_lector, str_as_array(raw_groups))
      .map do |retake|
      printed_name = day_names[retake[:week_day]]
      retake.merge({ week_day_printed: printed_name })
    end
  end

  # Я считаю, что 6 аргументов это нормально
  # Здесь никак переменные нельзя с агрегировать, да
  # и не считаю нужным знать контроллеру (который вызывает этот метод)
  # о каких-то агрегациях
  # rubocop:disable Metrics/ParameterLists
  def create_lecture(day_week, num_lecture, cabinet, lector, subject, groups)
    n_new_week_day = day_names.key(day_week)
    lecture = Lecture.new(subject, cabinet.to_i, str_as_array(groups), lector)
    created = @scheduler_service
              .add_lecture(n_new_week_day, num_lecture.to_i, lecture)

    { created: created }
  rescue StandardError => e
    marshal_error(e)
  end

  def delete_lecture(week_day, num_lecture, cabinet)
    lecture = find_by_time(week_day, num_lecture, cabinet)
    deleted = @scheduler_service.delete_lecture(lecture)
    deleted.nil? ? nil : deleted[:instance]
  end
  # rubocop:enable Metrics/ParameterLists

  # Я считаю, что 6 аргументов это нормально
  # Здесь никак переменные нельзя с агрегировать, да
  # и не считаю нужным знать контроллеру (который вызывает этот метод)
  # о каких-то агрегациях
  # rubocop:disable Metrics/ParameterLists
  def move_lecture(
    old_week_day, new_week_day,
    old_num_lecture, new_num_lecture,
    old_cabinet, new_cabinet
  )
    n_new_week_day = day_names.key(new_week_day)
    lecture = find_by_time(old_week_day, old_num_lecture, old_cabinet)

    updated = @updater_service.update(
      lecture, n_new_week_day, new_num_lecture
    ) { |l| l.cabinet = new_cabinet }

    { updated: updated }
  rescue BusinessException => e
    marshal_error(e)
  end
  # rubocop:enable Metrics/ParameterLists

  def day_names
    RefData.day_names
  end

  def find_by_time(day_week, num_lecture, cabinet)
    @scheduler_service
      .find_by_time(day_week, num_lecture, cabinet)
  end

  def save_changes
    scheduler = @scheduler_service.find
    @converter.write(scheduler)
  end

  def find_all_lectors
    @lector_service.find_lectors
  end

  def find_all_groups
    @group_service.find_groups
  end

  def find_workload(lector)
    @lector_service.find_workload(lector)
  end

  # -------------------------------------------
  private

  def marshal_error(error)
    { business_error: error }
  end

  def copy_hash_with_new_key(copiable_hash, key, value)
    new_hash = copy_hash(copiable_hash)
    new_hash[key] = value
    new_hash.freeze
  end

  def copy_hash(copiable_hash)
    hash = {}
    copiable_hash.each_pair do |k, v|
      hash[k] = v
    end
  end

  # Представляем строку элементов через запятую, как массив
  # При этом удаляем все пробелы
  def str_as_array(raw_str)
    raw_str.strip.gsub(' ', '').split(',')
  end
end
