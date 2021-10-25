# frozen_string_literal: true

require_relative 'bean/bean'
require_relative 'context'

# Default description change it
class Application
  include Bean

  def initialize
    Log.info('- Stating application')
    @context = Context.new
    Log.info('- Start injections')
    injections
    Log.info('- Start loading application')
    load
    Log.info('- Application started')
    start
  end

  # @abstract
  def load; end

  # @abstract
  def start; end
end
