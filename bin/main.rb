# frozen_string_literal: true

require_relative '../lib/scheduler_app'

def main
  SchedulerApp.new
end

main if __FILE__ == $PROGRAM_NAME
