# frozen_string_literal: true

require 'tty-prompt'
require_relative 'api/application'
require_relative 'app/command/controller'
require_relative 'app/reader/model_reader'
require_relative 'app/config/controller_config'

# Главный класс приложения
class SchedulerApp < Application
  def injections
    @context.add_bean_if_not_exist(TTY::Prompt, TTY::Prompt.new)

    @reader = inject(ModelReader)
    @command_config = inject(ControllerConfig)
    @controller = inject(Controller)
  end

  def load
    @reader.load
  end

  def start
    @controller.listen
  end
end
