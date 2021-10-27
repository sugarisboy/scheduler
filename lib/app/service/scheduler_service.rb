# frozen_string_literal: true

require_relative '../model/scheduler'
require_relative '../../../lib/api/bean/bean'
require_relative '../repository/scheduler_repository'

# Default description change it
class SchedulerService
  include Bean

  def injections
    @repository = inject(SchedulerRepository)
  end

  def add_lecture(day_week, num_lecture, lecture)
    lector = lecture.lector
    lector_fio = lector.fio

    query = @repository
                    .find_all_lectures
                    .day_week(day_week)
                    .num_lecture(num_lecture)

    check_is_free_group(lecture.groups, query)
    check_is_free_lector(lecture.lector, query)
  end

  private

  def check_is_free_group(groups, query)
    busy = groups.filter do |group|
      !query.groups_in(group).result.count.zero?
    end

    raise BusinessException, "Группы #{busy.join(', ')} заняты в это время" unless busy.empty?
  end

  def check_is_free_lector(lector, query)
    busy = query.lector(lector.fio).result.count.zero?

    raise BusinessException, "Лектор #{lector.fio} занят в это время" if busy
  end
end
