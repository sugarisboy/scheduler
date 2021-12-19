# frozen_string_literal: true

# Сущность: Лекция
class Lecture
  attr_accessor :subject, :cabinet, :groups, :lector

  def initialize(subject, cabinet, groups, lector)
    @subject = subject
    @cabinet = cabinet
    @groups = groups
    @lector = lector
  end

  def groups_as_str
    @groups.join(', ')
  end
end
