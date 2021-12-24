# frozen_string_literal: true

require 'roda'

require_relative 'models'
require_relative 'lib/scheduler_app'
require_relative 'lib/api/bean/bean'
require_relative 'lib/app/service/scheduler_service'
require_relative 'lib/app/service/lector_service'
require_relative 'lib/app/service/group_service'
require_relative 'lib/app/service/retake_service'
require_relative 'lib/app/service/aggregator_wrapper'
require_relative 'lib/app/validators/data_validator'

# Main router
class SchedulerWebApp < Roda
  opts[:root] = __dir__
  plugin :environments
  plugin :view_options
  plugin :hash_routes
  plugin :forme
  plugin :status_handler
  plugin :render

  configure :development do
    plugin :public
    opts[:serve_static] = true
  end

  status_handler(404) do |r|
    r.redirect('/menu')
  end

  opts[:app] = SchedulerApp.new
  opts[:wrapper] = opts[:app].context.inject(AggregatorWrapper)

  require_relative 'routes/menu_route'
  require_relative 'routes/lector_route'
  require_relative 'routes/retake_route'
  require_relative 'routes/scheduler_route'

  route do |r|
    r.public if opts[:serve_static]
    r.root { r.redirect('/menu') }

    r.hash_branches
  end
end
