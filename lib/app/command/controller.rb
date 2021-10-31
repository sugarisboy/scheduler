# frozen_string_literal: true

require_relative '../../api/bean/bean'

# Command holder
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
    rescue Interrupt; end
    listen
  end

  def add_commands(commands)
    commands.each { |cmd| add_command(cmd) }
  end

  def add_command(command)
    Log.debug("Add new command #{command.class}")
    raise TypeError, CANT_ADD_CMD_ERROR if !command.is_a? Command

    @commands << command
  end

  def command_info
    @commands.map do |command, i|
      "  #{i}. #{command.name}"
    end.join("\n")
  end
end
