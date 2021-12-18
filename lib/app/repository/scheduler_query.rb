# frozen_string_literal: true

# Класс-билдер для запроса с фильтрацией
class SchedulerQuery
  def initialize(repository, source)
    @repository = repository
    @source = source
  end

  # Поиск по кабинету
  def cabinet(cabinet)
    where(
      lambda do |lecture, _, _|
        lecture.cabinet.equal?(cabinet.to_i)
      end
    )
  end

  # Поиск по номеру дня
  def day_week(day_week)
    where(
      lambda do |_, day, _|
        day.equal?(day_week)
      end
    )
  end

  # Поиск по номеру лекции
  def num_lecture(num_lecture)
    where(
      lambda do |_, _, num|
        num.equal?(num_lecture)
      end
    )
  end

  # Поиск по учавствующей группе
  def groups_in(group)
    where(
      lambda do |lecture, _, _|
        lecture.groups.map(&:downcase).include?(group.to_s.downcase)
      end
    )
  end

  # Поиск по учавствующей группе
  def groups_any(groups)
    groups = groups.map(&:downcase)

    where(
      lambda do |lecture, _, _|
        lecture.groups.map(&:downcase).any? do |group|
          groups.include?(group.to_s.downcase)
        end
      end
    )
  end

  # Поиск по лектору
  def lector(lector)
    where(
      lambda do |lecture, _, _|
        lecture.lector.casecmp(lector).zero?
      end
    )
  end

  # Осуществить поиск и вернуть новое сформированное расписание
  def result
    @source
  end

  # Осуществить поиск и вернуть список лекций
  def lectures
    @source.map { |lecture| lecture }
  end

  private

  # Абстракная реализация для применения фильтров
  def where(criteria)
    new_source = @repository.find_by_criteria([criteria], @source)
    SchedulerQuery.new(@repository, new_source)
  end
end
