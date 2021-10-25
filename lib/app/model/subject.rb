# frozen_string_literal: true

# Subject
class Subject
  attr_accessor :name

  def initialize(name)
    @name = name
  end

  def to_s
    "#{self.class.name}[name=#{name}]"
  end
end
