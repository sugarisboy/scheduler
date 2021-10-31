# frozen_string_literal: true

require_relative 'command'
require_relative '../../api/bean/bean'
require_relative 'question/question_week_day'
require_relative 'question/question_num_lecture'
require_relative 'question/question_select_lecture'
require_relative '../service/scheduler_service'

# Command count patients info
class CommandChangeTime < Command
  include Bean

  def injections
    @service = inject(SchedulerService)
    @question_week_day = inject(QuestionWeekDay)
    @question_num_lecture = inject(QuestionNumLecture)
    @question_select_lecture = inject(QuestionSelectLecture)
  end

  def initialize
    super
    @name = 'Изменить дату и время лекции'
  end

  def execute
    puts 'Выберем изменяемую лекцию:'
    old_week_day = @question_week_day.ask
    old_num_lecture = @question_num_lecture.ask
    lectures = @service.lectures_by_time(old_week_day, old_num_lecture)
    lecture = @question_select_lecture.ask(lectures)

    puts 'Выберем новую дату и время:'
    new_week_day = @question_week_day.ask
    new_num_lecture = @question_num_lecture.ask

    @service.update_time(lecture, new_week_day, new_num_lecture)
  end
end
