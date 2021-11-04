# frozen_string_literal: true

require_relative 'lector_service'
require_relative '../../api/bean/bean'
require_relative '../repository/scheduler_repository'

# Сервис для работы с пересдачами
class RetakeService
  include Bean

  attr_accessor :day_count

  def injections
    @lector_service = inject(LectorService)
    @repository = inject(SchedulerRepository)
  end

  def find_retake_time(lector, groups)
    # Сформируем список знакомых кабинетов для лектора
    cabinets = @lector_service.find_cabinets(lector)

    # Для каждого дня попытаемся найти время для пересдачи
    (1..6).each do |day|
      result = find_retake_time_in_day(day, lector, groups, cabinets)
      return result unless result.nil?
    end

    nil
  end

  # Поиск пересдачи в конкретный день, для конкретного лектора и группы
  # С одной из указанных аудиторий
  def find_retake_time_in_day(day, lector, groups, cabinets)
    Log.debug("Find retake time in day = #{day} started")
    # Массив доступности, где i-ый элемент обозначает
    # i+1-ую пару и ее свободность или занятость
    free_matrix = Array.new(6, true)

    # Помечаем в массиве доступности пары, когда заняты группы
    exclude_busy_lectures_by_groups(free_matrix, day, groups)
    # Помечаем в массиве доступности пары, когжа занят лектор
    exclude_busy_lectures_by_lector(free_matrix, day, lector)

    Log.debug("Free matrix for day = #{day}: #{free_matrix}")

    # Формируем данные о свободных кабинет на каждой паре
    num_lecture_with_free_cabinets =
      find_free_cabinets(free_matrix, day, cabinets)

    Log.debug("Num lecture with free cabinets day = #{day}: " \
              "#{num_lecture_with_free_cabinets}")
    # Из проанализированных данных пытаемся найти
    # свободное время
    calculate(day, num_lecture_with_free_cabinets)
  end

  private

  def exclude_busy_lectures_by_groups(free_matrix, day, groups)
    @repository.find_all_lectures
               .groups_any(groups)
               .day_week(day)
               .result
               .each { |_, _, num| free_matrix[num - 1] = false }
  end

  def exclude_busy_lectures_by_lector(free_matrix, day, lector)
    @repository.find_all_lectures
               .lector(lector)
               .day_week(day)
               .result
               .each { |_, _, num| free_matrix[num - 1] = false }
  end

  def find_free_cabinets(free_matrix, day, cabinets)
    hash = {}

    free_matrix.each_with_index do |free, index|
      hash[index + 1] = free ? cabinets.dup : []
    end

    cabinets.each do |cabinet|
      @repository.find_all_lectures
                 .cabinet(cabinet)
                 .day_week(day)
                 .result
                 .each { |_, _, num| hash[num].delete(cabinet) }
    end

    hash
  end

  def calculate(day, hash)
    prev = []
    hash.each_pair do |num_lecture, value|
      cross = prev & value
      prev = value

      next if cross.empty?

      return {
        week_day: day,
        cabinet: cross.sample,
        num_lectures: [num_lecture - 1, num_lecture]
      }
    end
    nil
  end
end
