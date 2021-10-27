# frozen_string_literal: true

require_relative 'app/reader/model_reader'
require_relative 'api/context'
require_relative 'api/application'
require_relative 'app/model/scheduler'
require_relative 'app/model/lecture'
require_relative 'app/model/subject'
require_relative 'app/service/printer_service'
require_relative 'app/repository/scheduler_repository'
require_relative 'app/service/scheduler_service'
require_relative 'app/service/lector_service'

# Main class for scheduler app
class SchedulerApp < Application
  def injections
    @reader = inject(ModelReader)
    @scheduler_repository = inject(SchedulerRepository)
    @service = inject(SchedulerService)
    @lector_service = inject(LectorService)
  end

  def load
    @reader.load
  end

  def start
    puts 'loading scheduler:'

    scheduler = @scheduler_repository.scheduler
    #pp scheduler.map { |l| l }


    @lector_service.find_subjects('Фролова Ю. А.')

    #@scheduler_repository.find_all_lectures
    #                     .groups_in('ИТ-32')
    #                     .result
    #                     .each_lecture { |lecture| puts lecture }


    #subject = Subject.new('Технология производства')
    #cab = 104
    #group = ['ПИЭ-1']
    #lector = Lector.new('Трофимов П. Г.')
    #lecture = Lecture.new(subject, cab, group, lector)
    #@service.add_lecture(1, 3, lecture)
  end
end
