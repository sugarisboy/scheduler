# frozen_string_literal: true

require_relative '../../api/bean/bean'

# Default description change it
class BusinessValidator
  include Bean

  LECTOR_MAX_SUBJECTS = 8

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

  def check_workload_lector(lector_subjects, lector)
    count = lector_subjects.length
    overload = LECTOR_MAX_SUBJECTS <= count

    return unless overload

    error_msg = "Лектор #{lector} уже ведет #{LECTOR_MAX_SUBJECTS} пар," \
                'это число максимально для одного человека'

    raise BusinessException, error_msg
  end
end
