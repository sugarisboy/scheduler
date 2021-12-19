# frozen_string_literal: true

require_relative '../../api/bean/bean'

# Сервис для работы с лекторами
class LectorService
  include Bean

  def injections
    @repository = inject(SchedulerRepository)
  end

  # Поиск всех предметов у лектора
  def find_subjects(lector)
    subjects = find_lectures(lector)
               .map(&:subject)
               .uniq
    Log.debug("Founded subject for lector #{lector}: #{subjects}")
    subjects
  end

  # Поиск всех кабинетов у лектора
  def find_cabinets(lector)
    find_lectures(lector)
      .map(&:cabinet)
      .uniq
  end

  # Поиск всех групп у лектор
  def find_groups(lector)
    find_lectures(lector)
      .flat_map(&:groups)
      .uniq
  end

  # Поиск всех лекторов
  def find_lectors(scheduler = @repository.scheduler)
    scheduler.map { |lecture, _, _| lecture.lector }.sort.uniq
  end

  # Поиск лекций у лектора
  def find_lectures(lector)
    lectures_by_lector = @repository
                         .find_all_lectures
                         .lector(lector)
                         .lectures

    Log.debug("Founded lectures for lector #{lector}: #{lectures_by_lector}")
    lectures_by_lector
  end

  def find_workload(lector)
    {
      count: find_lectures(lector).count,
      subjects: find_subjects(lector),
      groups: find_groups(lector)
    }
  end
end
