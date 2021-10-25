# frozen_string_literal: true

# Родительский класс для классов-событий
class AbstractEvent
  attr_reader :event_type

  def initialize(event_type)
    @event_type = event_type
  end
end
