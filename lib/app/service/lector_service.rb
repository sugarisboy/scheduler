# frozen_string_literal: true

require_relative '../../api/bean/bean'

# Default description change it
class LectorService
  include Bean

  def injections
    @repository = inject(SchedulerRepository)
  end

  def find_subjects(lector)
    subjects = find_lectures(lector)
               .map(&:subject)
               .uniq
    Log.debug("Founded subject for lector #{lector}: #{subjects}")
    subjects
  end

  def find_cabinets(lector)
    find_lectures(lector)
      .map(&:cabinet)
      .uniq
  end

  def find_groups(lector)
    find_lectures(lector)
      .flat_map(&:groups)
      .uniq
  end

  def find_lectors(scheduler = @repository.scheduler)
    scheduler.map { |lecture, _, _| lecture.lector }.sort.uniq
  end

  def find_lectures(lector)
    lectures_by_lector = @repository
                         .find_all_lectures
                         .lector(lector)
                         .lectures

    Log.debug("Founded lectures for lector #{lector}: #{lectures_by_lector}")
    lectures_by_lector
  end
end
