# frozen_string_literal: true

# Default description change it
class Validator
  def between?(min, value, max, field)
    not_nil?(value, field)
    return if value.to_i.between?(min, max)

    raise "Value '#{field}' must be between (#{min}, #{max}), actual: #{value}"
  end

  def not_zero?(value, field)
    not_nil?(value, field)
    return if !value.to_i.zero?

    raise "Value '#{field}' must be number and isn't zero, actual: #{value}"
  end

  def not_nil?(value, field)
    raise "Value '#{field}' can't be null" if value.nil?
  end

  def not_empty?(value, field)
    not_nil?(value, field)
    raise "Value '#{field} can't be empty" if value.to_s.strip.empty?
  end
end
