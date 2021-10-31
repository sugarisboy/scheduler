# frozen_string_literal: true

require_relative 'command'
require_relative 'question/question_week_day'
require_relative 'question/question_num_lecture'
require_relative 'question/question_select_lecture'
require_relative '../service/scheduler_service'
require_relative '../../api/bean/bean'

# Команда для удаления элемента раписания
class CommandRemoveElement < Command
  include Bean

  def injections
    @question_week_day = inject(QuestionWeekDay)
    @question_num_lecture = inject(QuestionNumLecture)
    @question_select_lecture = inject(QuestionSelectLecture)
    @service = inject(SchedulerService)
  end

  def initialize
    super
    @name = 'Удалить элемент расписания'
  end

  def execute
    week_day = @question_week_day.ask
    num_lecture = @question_num_lecture.ask
    lectures = @service.lectures_by_time(week_day, num_lecture)
    lecture = @question_select_lecture.ask(lectures)

    @service.delete_lecture(lecture)
  end
end
