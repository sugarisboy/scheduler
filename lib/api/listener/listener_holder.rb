# frozen_string_literal: true

require_relative '../bean/bean'

# Default description change it
class ListenerHolder
  include Bean

  def initialize
    @listeners = []
  end

  def add(listener)
    @listeners << listener
  end
end
