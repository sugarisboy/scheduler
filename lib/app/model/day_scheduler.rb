# frozen_string_literal: true

# Сущность: День каледаря
class DayScheduler
  attr_reader :data

  def initialize
    @data = {}

    (1..6).each do |n|
      @data[n] = []
    end

    @data.freeze
  end

  def sorted_data
    result = {}
    @data.each_pair do |key, value|
      result[key] = value.sort_by(&:cabinet)
    end
    result
  end
end
