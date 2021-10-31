# frozen_string_literal: true

# Command
class Command
  attr_reader :name

  # @abstract
  def execute
    error_msg = format(
      '%<class>s has not implemented method %<method>s',
      {
        class: self.class,
        method: __method__
      }
    )
    raise NotImplementedError, error_msg
  end

  # Возвращает true, если после данной команды
  # приложение останавливается
  def end_session?
    false
  end
end
