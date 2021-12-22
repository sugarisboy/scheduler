# frozen_string_literal: true

require_relative '../model/ref_data'
require_relative '../service/retake_service'
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
    @converter = inject(ModelFileConverter)
  end

  def search_retakes(raw_lector, raw_groups)
    groups = split_arr(raw_groups)
    @retake_service
      .find_retake_time(raw_lector, groups)
      .map do |retake|
      copy_hash_with_new_key(
        retake,
        :week_day_printed,
        RefData.day_names[retake[:week_day]]
      )
    end
  end

  def delete_lecture(week_day, num_lecture, cabinet)
    lecture = find_by_time(week_day, num_lecture, cabinet)
    @scheduler_service.delete_lecture(lecture)
  end

  # rubocop:disable Metrics/ParameterLists
  # Я считаю, что 6 аргументов это нормально
  # Здесь никак переменные нельзя с агрегировать, да
  # и не считаю нужным знать контроллеру (который вызывает этот метод)
  # о каких-то агрегациях
  def move_lecture(
    old_week_day, new_week_day,
    old_num_lecture, new_num_lecture,
    old_cabinet, new_cabinet
  )
    n_new_week_day = day_names.key(new_week_day)

    lecture = find_by_time(old_week_day, old_num_lecture, old_cabinet)

    begin
      updated = @updater_service
                .update(lecture, n_new_week_day, new_num_lecture) do |changeable|
        changeable.cabinet = new_cabinet
      end

      { updated: updated }
    rescue BusinessException => e
      { business_error: e }
    end
  end

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

  private

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
  def split_arr(raw_str)
    raw_str.strip.gsub(' ', '').split(',')
  end
end
