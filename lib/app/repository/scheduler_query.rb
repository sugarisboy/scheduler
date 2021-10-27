# frozen_string_literal: true

# Default description change it
class SchedulerQuery
  def initialize(repository, source)
    @repository = repository
    @source = source
  end

  # Поиск по кабинету
  def cabinet(cabinet)
    where(
      lambda do |lecture, day, num|
        lecture.cabinet == cabinet
      end
    )
  end

  # Поиск по номеру дня
  def day_week(day_week)
    where(
      lambda do |lecture, day, num|
        day == day_week
      end
    )
  end

  # Поиск по номеру лекции
  def num_lecture(num_lecture)
    where(
      lambda do |lecture, day, num|
        num == num_lecture
      end
    )
  end

  # Поиск по учавствующей группе
  def groups_in(group)
    where(
      lambda do |lecture, day, num|
        lecture.groups.map(&:downcase).include?(group.to_s.downcase)
      end
    )
  end

  # Поиск по лектору
  def lector(lector_fio)
    where(
      lambda do |lecture, day, num|
        lecture.lector.fio.casecmp(lector_fio).zero?
      end
    )
  end

  # Осуществитьб поиск и вернуть список лекций
  def result
    @source
  end

  def lectures
    @source.map { |lecture| lecture }
  end

  private

  def where(criteria)
    new_source = @repository.find_by_criteria([criteria], @source)
    SchedulerQuery.new(@repository, new_source)
  end
end
