# frozen_string_literal: true

require 'tty-prompt'
require_relative 'question'
require_relative '../../model/lecture'
require_relative '../../validators/data_validator'
require_relative '../../../api/bean/bean'

# Вопрос о создаваемой лекции
class QuestionCreateLecture < Question
  include Bean

  def injections
    @prompt = inject(TTY::Prompt)
    @data_validator = inject(DataValidator)
  end

  def ask
    groups = input_groups
    lector = input_lector
    subject = input_subject
    cabinet = input_cabinet

    puts "#{groups}|#{lector}|#{subject}|#{cabinet}"
    Lecture.new(subject, cabinet, groups, lector)
  end

  def input_subject
    input 'Укажите название предмета: ' do |subject|
      @data_validator.validate_subject(subject)
      subject
    end
  end

  def input_groups
    input 'Укажите список групп через запятую: ' do |groups|
      groups = groups.strip.gsub(' ', '').split(',')
      @data_validator.validate_groups(groups)
      groups
    end
  end

  def input_cabinet
    input 'Укажите номер кабинета: ' do |cabinet|
      @data_validator.validate_cabinet(cabinet)
      cabinet.to_i
    end
  end

  def input_lector
    input 'Укажите ФИО лектора: ' do |lector|
      @data_validator.validate_lector(lector)
      lector
    end
  end
end
