# frozen_string_literal: true

require_relative '../../api/exception/validation_exception'

# Родительский класс для валидаторов с базовым функционалом проверок
class Validator
  def between?(min, value, max, field)
    not_nil?(value, field)
    return if value.to_i.between?(min, max)

    not_valid "Значание '#{field}' должно быть между (#{min}, #{max}), " \
              "предоставлено: #{value}"
  end

  def not_zero?(value, field)
    not_nil?(value, field)
    return if !value.to_i.zero?

    not_valid "Значание '#{field}' должно быть числом отличнымо от нуля, " \
              "предоставлено: #{value}"
  end

  def not_nil?(value, field)
    not_valid "Значение '#{field}' не может отсутствовать" if value.nil?
  end

  def not_empty?(value, field)
    not_nil?(value, field)
    if value.to_s.strip.empty?
      not_valid "Значение '#{field}' не может быть пустым"
    end
  end

  def positive?(value, field)
    not_zero?(value, field)
    not_valid "Значение '#{field}' отрицательное" if value.to_i.negative?
  end

  def not_valid(msg)
    raise ValidationException, msg
  end
end
