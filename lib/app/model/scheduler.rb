# frozen_string_literal: true

require_relative 'day_scheduler'
require_relative '../../../lib/api/bean/bean'

# Scheduler
class Scheduler
  include Bean

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
end
