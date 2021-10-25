# frozen_string_literal: true

# Класс для бизнесовых ошибок
class BusinessException < StandardError
  def initialize(msg = nil)
    super
  end
end
