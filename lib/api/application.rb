# frozen_string_literal: true

require_relative 'context'
require_relative 'bean/bean'
require_relative 'utils/io_utils'
require_relative 'exception/business_exception'

# Родительский класс для главного класса приложения
class Application
  include Bean

  def initialize(context = Context.new)
    Log.info('- Stating application')
    @context = context
    up_context
  end

  # Поднятие контекста приложения
  def up_context
    Log.info('- Start injections')
    injections
    Log.info('- Start loading application')
    load
    Log.info('- Application started')
    start
  rescue BusinessException => e
    Log.error(IOUtils.as_red(e))
  end

  # @abstract
  # Метод для загрузки приложения
  def load; end

  # @abstract
  # Метод для вызова основного функционала приложения
  def start; end
end
