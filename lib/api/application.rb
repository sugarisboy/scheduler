# frozen_string_literal: true

require_relative 'bean/bean'
require_relative 'context'
require_relative 'exception/business_exception'
require_relative 'utils/io_utils'

# Default description change it
class Application
  include Bean

  def initialize(context = Context.new)
    Log.info('- Stating application')
    @context = context
    up_context
  end

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
  def load; end

  # @abstract
  def start; end
end
