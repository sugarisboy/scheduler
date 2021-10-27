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
    Log.debug("Start create lecture #{day_week},#{num_lecture},#{lecture}")

    @validator.validate_day_week(day_week)
    @validator.validate_num_lecture(num_lecture)

    day = @scheduler.data[day_week]
    num = day.data[num_lecture]
    num << lecture
    Log.debug("Finish creating lecture #{day_week},#{num_lecture},#{lecture}")
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

  def just
    "do it"
  end
end
