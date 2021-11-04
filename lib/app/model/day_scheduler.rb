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
end
