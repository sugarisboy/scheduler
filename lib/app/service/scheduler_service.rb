# frozen_string_literal: true

require_relative '../model/scheduler'
require_relative '../service/lector_service'
require_relative '../repository/scheduler_repository'
require_relative '../../../lib/api/bean/bean'

# Default description change it
class SchedulerService
  include Bean

  LECTOR_MAX_SUBJECTS = 8

  def injections
    @repository = inject(SchedulerRepository)
    @lector_service = inject(LectorService)
  end

  def add_lecture(day_week, num_lecture, lecture)
    Log.debug("Start create lecture #{day_week},#{num_lecture},#{lecture}")

    query = @repository
              .find_all_lectures
              .day_week(day_week)
              .num_lecture(num_lecture)

    # Проверка что группа не занята в это время
    check_is_free_group(lecture.groups, query)

    # Проверка что лектор не ведет пару в это время
    check_is_free_lector(lecture.lector, query)

    # Проверка что кабинет свободен в это время
    check_is_free_cabinet(lecture.cabinet, query)

    # Проверка загруженности лектора
    check_workload_lector(lecture.lector)

    result = @repository.save_lecture(day_week, num_lecture, lecture)
    Log.debug("Finish creating lecture #{day_week},#{num_lecture},#{lecture}")
    result
  end

  def delete_lecture(lecture)
    info_about_removable = @repository.find_lecture(lecture, extend: true)
    raise "Not fount lecture: #{lecture}" if info_about_removable.nil?

    deleted = @repository.delete_lecture(
      info_about_removable[:day_week],
      info_about_removable[:num_lecture],
      lecture
    )

    raise "Can't delete lecture #{lecture}" if deleted.nil?

    info_about_removable
  end

  def update_time(lecture, new_day, new_num)
    deleted = delete_lecture(lecture)

    begin
      add_lecture(new_day, new_num, lecture)
    rescue StandardError => e
      add_lecture(deleted[:day_week], deleted[:num_lecture], lecture)
      raise BusinessException, "Ошибка при изменении времени для лекции: #{e}"
    end
  end

  def update(lecture)
    raise 'Use block for update lecture' unless block_given?

    deleted = delete_lecture(lecture)
    old = deleted.instance

    changeable = Lecture.new(old.subject, old.cabinet, old.groups, old.lector)

    changeable = yield changeable

    begin
      add_lecture(info.day_week, info.num_lecture, changeable)
    rescue StandardError => e
      add_lecture(info.day_week, info.num_lecture, deleted)
      raise BusinessException, "Change data for #{lecture} failed: #{e}"
    end
  end

  def lectures_by_time(week_day, num_lecture)
    @repository.find_all_lectures
               .day_week(week_day)
               .num_lecture(num_lecture)
               .result
  end

  def find
    @repository.scheduler
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

  private

  def check_is_free_group(groups, query)
    busy = groups.filter do |group|
      !query.groups_in(group).result.count.zero?
    end

    return if busy.empty?

    raise BusinessException, "Группы #{busy.join(', ')} заняты в это время"
  end

  def check_is_free_lector(lector, query)
    free = query.lector(lector).result.count.zero?

    return if free

    raise BusinessException, "Лектор #{lector} занят в это время"
  end

  def check_is_free_cabinet(cabinet, query)
    free = query.cabinet(cabinet).result.count.zero?

    return if free

    raise BusinessException, "Кабинет #{cabinet} занят в это время"
  end

  def check_workload_lector(lector)
    lector_subjects = @lector_service.find_subjects(lector)
    count = lector_subjects.length
    overload = LECTOR_MAX_SUBJECTS <= count

    return unless overload

    error_msg = "Лектор #{lector} уже ведет #{LECTOR_MAX_SUBJECTS} пар," \
                'это число максимально для одного человека'

    raise BusinessException, error_msg
  end
end
