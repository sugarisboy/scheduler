# frozen_string_literal: true

require_relative 'listener_holder'
require_relative '../bean/bean'

# Родительский класс для слушателя событий
class AbstractListener
  include Bean

  def initialize
    return if self.class.instance_of?(AbstractListener.class)

    @context.find(ListenerHolder)
            .add(self)
  end

  # Not override this method
  def catch(event)
    listen(event) if event.instance_of?(@event_type)
  end

  # @abstract
  def listen(_event)
    raise NotImplementedError
  end
end
