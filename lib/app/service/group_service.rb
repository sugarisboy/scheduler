# frozen_string_literal: true

require_relative '../../api/bean/bean'

# Default description change it
class GroupService
  include Bean

  def injections
    @repository = inject(SchedulerRepository)
  end

  def find_groups(scheduler = @repository.scheduler)
    groups = scheduler.flat_map do |lecture, _, _|
      lecture.groups
    end
    
    groups.uniq.sort
  end
end
