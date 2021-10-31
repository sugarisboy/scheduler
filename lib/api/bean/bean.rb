# frozen_string_literal: true

require 'logger'

# Класс для объеденения нескольких классов в один
# Реализация Dependency Injection
module Bean
  Log = Logger.new($stdout)

  # Региструрует в контексте самого себя, чтобы другие бины
  # могли внедрить данный компонент
  # P. S. Принимает в качестве аргумента контекст,
  # к которому привязывается для дальнейшего использования
  def register_bean(context)
    Log.level = Logger::INFO
    Log.info("Register bean #{self.class.name}")
    @context = context
    context.add_bean(self)
    injections
    post_initialize
    self
  end

  # @abstract
  # Метод для этапа внедрения зависимостей
  def injections; end

  # @abstract
  # Метод, вызывающийся после этапа внедрения зависимостей
  def post_initialize; end

  # Метод для внедрения зависимостей
  def inject(type)
    @context.inject(type)
  end
end
