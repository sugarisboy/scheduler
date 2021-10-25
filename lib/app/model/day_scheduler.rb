# frozen_string_literal: true

# Subject
class DayScheduler
  attr_reader :data

  def initialize
    @data = {}

    (1..6).each do |n|
      @data[n] = []
    end

    @data.freeze
  end

  def to_s
    "#{self.class.name}[data=#{data}]"
  end
end
