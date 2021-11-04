# frozen_string_literal: true

require_relative 'command'
require_relative 'question/question_week_day'
require_relative 'question/question_num_lecture'
require_relative 'question/question_create_lecture'
require_relative '../service/scheduler_service'
require_relative '../model/lecture'
require_relative '../../api/bean/bean'

# Команда для добавления элемента в расписание
class CommandAddElement < Command
  include Bean

  def injections
    @question_week_day = inject(QuestionWeekDay)
    @question_num_lecture = inject(QuestionNumLecture)
    @question_create_lecture = inject(QuestionCreateLecture)
    @service = inject(SchedulerService)
  end

  def initialize
    super
    @name = 'Добавить элемент расписания'
  end

  def execute
    week_day = @question_week_day.ask
    num_lecture = @question_num_lecture.ask
    lecture = @question_create_lecture.ask

    @service.add_lecture(week_day, num_lecture, lecture)
  end
end
