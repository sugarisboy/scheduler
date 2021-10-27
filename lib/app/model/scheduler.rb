# frozen_string_literal: true

require_relative 'day_scheduler'

# Scheduler
class Scheduler

  attr_reader :data

  def initialize
    @data = {}

    (1..6).each do |n|
      @data[n] = DayScheduler.new
    end

    @data.freeze
  end

  def day(day_week)
    @data.key?(day_week) ? @data[day_week] : nil
  end

  def to_s
    "#{self.class.name}[data=#{data}]"
  end

  def each_lecture
    return enum_for(:iterator) unless block_given?

    @data.each_pair do |day_week, day_data|
      day_data.data.each_pair do |num_lecture, lectures|
        lectures.each do |lecture|
          yield lecture, day_week, num_lecture
        end
      end
    end
  end

  def select_lecture
    return enum_for(:select) unless block_given?

    response = Scheduler.new
    each_lecture do |lecture, day, num|
      response.data[day].data[num].push(lecture) if yield lecture, day, num
    end

    response
  end

  def map
    return enum_for(:map) unless block_given?

    result = []
    each_lecture do |lecture, day, num|
      value = yield lecture, day, num
      result << value
    end
    result
  end

  def count
    count = 0
    each_lecture { |_, _, _| count += 1 }
    count
  end
end
