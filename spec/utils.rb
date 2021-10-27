# frozen_string_literal: true

# Default description change it
class TestContext < Context
  def bean(type, value)
    @bean_factory.primary(type, value)
    self
  end

  def instance(type)
    @bean_factory.create_new(type)
  end
end
