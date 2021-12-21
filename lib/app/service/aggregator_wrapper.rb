# frozen_string_literal: true

require_relative '../model/ref_data'
require_relative '../service/retake_service'
require_relative '../../api/bean/bean'

# Преобразует данные с фронта в данные для бека
class AggregatorWrapper
  include Bean

  def injections
    @retake_service = inject(RetakeService)
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
