# frozen_string_literal: true

require 'logger'

# Класс для объеденения нескольких классов в один
# Реализация Dependency Injection
module Bean
  Log = Logger.new($stdout)

  def register_bean(context)
    Log.debug("Register bean #{self.class.name}")
    @context = context
    context.add_bean(self)
    injections
    self
  end

  # @abstract
  def injections; end

  def inject(type)
    @context.inject(type)
  end
end
