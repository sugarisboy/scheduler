# frozen_string_literal: true

require_relative '../service/scheduler_service'
require_relative '../../../lib/api/bean/bean'
require_relative '../../../lib/api/exception/business_exception'
# Default description change it
class UpdaterService
  include Bean

  def injections
    @scheduler_service = inject(SchedulerService)
  end

  def update_time(lecture, new_day, new_num)
    deleted = @scheduler_service.delete_lecture(lecture)

    begin
      @scheduler_service.add_lecture(
        new_day, new_num, lecture
      )
    rescue StandardError => e
      @scheduler_service.add_lecture(
        deleted[:day_week], deleted[:num_lecture], lecture
      )
      raise BusinessException, "Ошибка при изменении времени для лекции: #{e}"
    end
  end

  def update(lecture)
    raise 'Use block for update lecture' unless block_given?

    deleted = @scheduler_service.delete_lecture(lecture)
    old = deleted[:instance]

    changeable = Lecture.new(old.subject, old.cabinet, old.groups, old.lector)
    yield changeable

    begin
      @scheduler_service.add_lecture(
        deleted[:day_week], deleted[:num_lecture], changeable
      )
    rescue StandardError => e
      @scheduler_service.add_lecture(
        deleted[:day_week], deleted[:num_lecture], lecture
      )
      raise BusinessException, "Ошибка при изменении данных лекции: #{e}"
    end
  end
end
