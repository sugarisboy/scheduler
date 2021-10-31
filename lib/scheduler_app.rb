# frozen_string_literal: true

require 'tty-prompt'
require_relative 'api/application'
require_relative 'app/command/controller'
require_relative 'app/reader/model_reader'
require_relative 'app/config/command_config'

# Main class for scheduler app
class SchedulerApp < Application
  def injections
    # Creating bean from external dependencies
    @context.add_bean_if_not_exist(TTY::Prompt, TTY::Prompt.new)

    # Inject my dependencies
    @reader = inject(ModelReader)
    @command_config = inject(CommandConfig)
    @controller = inject(Controller)
  end

  def load
    @reader.load
  end

  def start
    @controller.listen
  end
end
