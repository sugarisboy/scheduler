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
               .map(&:name)
               .uniq
    Log.debug("Founded subject for lector #{lector}: #{subjects}")
    subjects
  end

  def find_lectures(lector)
    lectures_by_lector = @repository
                         .find_all_lectures
                         .lector(lector)
                         .lectures
    Log.debug("Founded lectures for lector #{lector}: #{lectures_by_lector}")
    lectures_by_lector
  end

  # Simple method for first test
  def simple
    'dimple'
  end

  # Simple method for second test with using inejectable objects
  def simple2
    @repository.just
  end
end
