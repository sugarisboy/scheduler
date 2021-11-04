# frozen_string_literal: true

require_relative '../model/scheduler'
require_relative '../service/lector_service'
require_relative '../repository/scheduler_repository'
require_relative '../validators/business_validator'
require_relative '../../../lib/api/bean/bean'

# Сервис для работы с расписанием
class SchedulerService
  include Bean

  def injections
    @repository = inject(SchedulerRepository)
    @lector_service = inject(LectorService)
    @business_validator = inject(BusinessValidator)
  end

  def add_lecture(day_week, num_lecture, lecture)
    Log.debug("Start create lecture #{day_week},#{num_lecture},#{lecture}")

    query = @repository
            .find_all_lectures
            .day_week(day_week)
            .num_lecture(num_lecture)

    # Проверка что группа не занята в это время
    @business_validator.check_is_free_group(lecture.groups, query)

    # Проверка что лектор не ведет пару в это время
    @business_validator.check_is_free_lector(lecture.lector, query)

    # Проверка что кабинет свободен в это время
    @business_validator.check_is_free_cabinet(lecture.cabinet, query)

    # Проверка загруженности лектора
    lector = lecture.lector
    lector_subjects = @lector_service.find_subjects(lector)
    @business_validator.check_workload_lector(lector_subjects, lector)

    result = @repository.save_lecture(day_week, num_lecture, lecture)
    Log.debug("Finish creating lecture #{day_week},#{num_lecture},#{lecture}")
    result
  end

  def delete_lecture(lecture)
    info_about_removable = @repository.find_lecture(lecture, extend: true)
    raise "Not found lecture: #{lecture}" if info_about_removable.nil?

    deleted = @repository.delete_lecture(
      info_about_removable[:day_week],
      info_about_removable[:num_lecture],
      lecture
    )
    raise "Can't delete lecture #{lecture}" if deleted.nil?

    info_about_removable
  end

  def find
    @repository.scheduler
  end

  def lectures_by_time(week_day, num_lecture)
    @repository.find_all_lectures
               .day_week(week_day)
               .num_lecture(num_lecture)
               .result
  end

  def find_by_group(group)
    @repository.find_all_lectures.groups_in(group).result
  end

  def find_by_any_groups(groups)
    @repository.find_all_lectures.groups_any(groups).result
  end

  def find_by_lector(lector)
    @repository.find_all_lectures.lector(lector).result
  end

  def find_by_cabinet(cabinet)
    @repository.find_all_lectures.cabinet(cabinet).result
  end
end
