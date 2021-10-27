# frozen_string_literal: true

# Default description change it
class BusinessException < StandardError
  def initialize(msg = nil)
    super
  end
end
