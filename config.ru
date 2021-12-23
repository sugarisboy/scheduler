# frozen_string_literal: true

require_relative 'scheduler_web_app'
require_relative 'lib/scheduler_app'

run SchedulerWebApp.freeze.app
