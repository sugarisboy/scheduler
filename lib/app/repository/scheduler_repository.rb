# frozen_string_literal: true

require_relative '../../../lib/api/bean/bean'
require_relative '../validators/data_validator'
require_relative '../model/scheduler'
require_relative 'scheduler_query'
require 'logger'

# Default description change it
class SchedulerRepository
  include Bean

  attr_reader :scheduler

  def initialize
    @scheduler = Scheduler.new
  end

  def injections
    @validator = inject(DataValidator)
  end

  # Сохранение лекции с минимальной проверкой на тип данных
  def save_lecture(day_week, num_lecture, lecture)
    @validator.validate_day_week(day_week)
    @validator.validate_num_lecture(num_lecture)

    day = @scheduler.data[day_week]
    num = day.data[num_lecture]
    num << lecture
  end

  # Вовзращает билдер запроса по поиску лекций
  def find_all_lectures
    SchedulerQuery.new(self, @scheduler)
  end

  # Осуществляет поиск среди всех лекций по критериям
  def find_by_criteria(criteria, data = @scheduler)
    Log.debug("Call find by criteria from #{data.count} elements")
    result = data.select_lecture do |lecture, day, num|
      criteria.all? do |condition|
        condition.call(lecture, day, num)
      end
    end
    Log.debug("Criteria query finished, founded #{result.count} elements")
    result
  end

  # TODO: test remove two elems with equals data, but difference time
  def delete_lecture(day_week, num_lecture, lecture)
    @scheduler.data[day_week]
              .data[num_lecture]
              .delete(lecture)
  end

  # @param [FalseClass] extend сообщает об получение расширенной информации
  def find_lecture(lecture, extend: false)
    @scheduler.each do |lec, day, num|
      next if lec != lecture

      return lec unless extend

      return {
        day_week: day,
        num_lecture: num,
        instance: lec
      }
    end
  end
end
