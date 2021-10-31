# frozen_string_literal: true

require_relative 'command'
require_relative 'question/question_cabinet'
require_relative 'question/question_week_day'
require_relative 'question/question_num_lecture'
require_relative 'question/question_select_lecture'
require_relative '../service/scheduler_service'
require_relative '../../api/bean/bean'

# Команда изменения даты и времени у элемента расписания
class CommandChangeCabinet < Command
  include Bean

  def injections
    @service = inject(SchedulerService)
    @question_week_day = inject(QuestionWeekDay)
    @question_num_lecture = inject(QuestionNumLecture)
    @question_select_lecture = inject(QuestionSelectLecture)
    @question_cabinet = inject(QuestionCabinet)
  end

  def initialize
    super
    @name = 'Изменить номер кабинета для лекции'
  end

  def execute
    puts 'Выберем изменяемую лекцию:'
    old_week_day = @question_week_day.ask
    old_num_lecture = @question_num_lecture.ask
    lectures = @service.lectures_by_time(old_week_day, old_num_lecture)
    lecture = @question_select_lecture.ask(lectures)

    cabinet = @question_cabinet.ask('Введите номер нового кабинета: ')

    @service.update(lecture) { |instance| instance.cabinet = cabinet }
  end
end
