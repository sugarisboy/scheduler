# frozen_string_literal: true

# Lecture
class Lecture
  attr_accessor :subject, :cabinet, :groups, :lector

  def initialize(subject, cabinet, groups, lector)
    @subject = subject
    @cabinet = cabinet
    @groups = groups
    @lector = lector
  end

  def to_s
    "#{self.class.name}" \
      "[subj=#{subject},cab=#{cabinet},groups=#{groups},lector=#{lector}]"
  end
end
