# frozen_string_literal: true

require_relative '../../api/bean/bean'
require_relative '../command/controller'
require_relative '../command/command_add_element'
require_relative '../command/command_print_all'
require_relative '../command/command_remove_element'
require_relative '../command/command_change_time'
require_relative '../command/command_exit'
require_relative '../command/command_print_criteria'
require_relative '../command/command_find_retake'
require_relative '../command/command_get_workload'

# Default description change it
class CommandConfig
  include Bean

  def injections
    @command_holder = inject(Controller)
    @commands = [
      inject(CommandAddElement),
      inject(CommandRemoveElement),
      inject(CommandChangeTime),
      inject(CommandPrintAll),
      inject(CommandPrintCriteria),
      inject(CommandFindRetake),
      inject(CommandGetWorkload),
      inject(CommandExit)
    ]
  end

  # Called after injections
  def post_initialize
    configure
  end

  def configure
    @command_holder.add_commands(@commands)
  end
end
