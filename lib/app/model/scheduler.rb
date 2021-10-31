# frozen_string_literal: true

require_relative 'day_scheduler'

# Сущность: Календарь
class Scheduler
  include Enumerable

  attr_reader :data

  def initialize
    @data = {}

    (1..6).each do |n|
      @data[n] = DayScheduler.new
    end

    @data.freeze
  end

  def to_s
    "#{self.class.name}[data=#{data}]"
  end

  # Основной методя для становления Enumerable
  def each
    raise 'Need block' unless block_given?

    @data.each_pair do |day_week, day_data|
      day_data.data.each_pair do |num_lecture, lectures|
        lectures.each do |lecture|
          yield lecture, day_week, num_lecture
        end
      end
    end
  end

  # Кастомный метод для поиск лекций с возвратом нового расписания
  def select_lecture
    raise 'Need block' unless block_given?

    response = Scheduler.new
    each do |lecture, day, num|
      response.data[day].data[num].push(lecture) if yield lecture, day, num
    end

    response
  end
end
