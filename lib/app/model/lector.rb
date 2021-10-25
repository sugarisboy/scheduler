# frozen_string_literal: true

# Lector
class Lector
  attr_accessor :fio

  def initialize(fio)
    @fio = fio
  end

  def to_s
    "#{self.class.name}[fio=#{fio}]"
  end
end
