# frozen_string_literal: true

require_relative '../lib/scheduler'

def main
  Scheduler.new.menu
end

main if __FILE__ == $PROGRAM_NAME
