# frozen_string_literal: true

require_relative '../../api/bean/bean'

# Сервис для работы с группами
class GroupService
  include Bean

  def injections
    @repository = inject(SchedulerRepository)
  end

  # Поиск всех групп в раписании
  def find_groups(scheduler = @repository.scheduler)
    groups = scheduler.flat_map do |lecture, _, _|
      lecture.groups
    end
    
    groups.uniq.sort
  end
end
