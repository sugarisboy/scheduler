# frozen_string_literal: true

# Класс для ошибок валидации
class ValidationException < StandardError
  def initialize(msg = nil)
    super
  end
end
