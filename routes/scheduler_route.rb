# frozen_string_literal: true

require_relative '../lib/api/bean/bean'
require_relative '../lib/app/service/scheduler_service'

# Default description change it
class SchedulerRoute
  hash_branch('scheduler') do |r|

    # GET /scheduler
    r.root do
      response = ''
      @service.find do |lecture|
        response += "#{lecture.subject}"
      end
      response
    end
  end
end