# frozen_string_literal: true

require_relative '../../api/bean/bean'

# Контроллер приложения
# Слушаюший действия пользователя и отвечающий на его запросы
class Controller
  include Bean

  CANT_ADD_CMD_ERROR = 'Can\'t push command to holder if ' \
                       'it is not instance of Command'

  def initialize
    @commands = []
  end

  def injections
    @prompt = inject(TTY::Prompt)
  end

  # Метод запуска прослушивания действия пользователя
  def listen
    choice = @commands.map do |command|
      { name: command.name, value: command }
    end

    begin
      cmd = @prompt.select('Выберите желаемую операцию', choice, per_page: 10)
      return if cmd.end_session?

      cmd.execute
    rescue BusinessException => e
      puts IOUtils.as_red(e)
    rescue Interrupt => _e
      Log.error('Controller was stopped')
    end
    listen
  end

  # Добавление комманд для контроллера
  def add_commands(commands)
    commands.each { |cmd| add_command(cmd) }
  end

  # Добавление комманды для контроллера
  def add_command(command)
    Log.debug("Add new command #{command.class}")
    raise TypeError, CANT_ADD_CMD_ERROR if !command.is_a? Command

    @commands << command
  end
end
