# frozen_string_literal: true

require_relative 'lib/scheduler_app'
require 'roda'
require_relative 'lib/api/bean/bean'
require_relative 'lib/app/service/scheduler_service'
require_relative 'lib/app/service/lector_service'
require_relative 'lib/app/service/group_service'
require_relative 'lib/app/validators/data_validator'

# Main router
class App < Roda

  opts[:root] = __dir__
  plugin :environments
  plugin :forme
  plugin :hash_routes
  plugin :path
  plugin :render
  plugin :status_handler
  plugin :view_options
  plugin :default_headers, 'Content-Type' => 'text/html; charset=utf-8'

  configure :development do
    plugin :public
    opts[:serve_static] = true
  end

  status_handler(404) do
    'NOT FOUND'
  end

  opts[:app] = SchedulerApp.new

  route do |r|
    r.public if opts[:serve_static]
    r.hash_branches
  end

  hash_branch('scheduler') do |r|
    append_view_subdir('scheduler')
    set_layout_options(template: '../views/layout')

    @parameters = {}
    r.params.each { |k, v| @parameters[k] = v }

    context = opts[:app].context
    @service = context.inject(SchedulerService)
    @group_service = context.inject(GroupService)
    @lector_service = context.inject(LectorService)

    r.get 'list' do
      view(
        'lectures_list',
        locals: {
          scheduler: @service.find_by_filters(
            @parameters['lector'] || '',
            @parameters['cabinet'] || '',
            @parameters['group'] || ''
          ),
          groups: @group_service.find_groups,
          lectors: @lector_service.find_lectors
        }
      )
    end

    r.on 'add' do
      r.get do
        view(
          'add_lecture',
          locals: { parameters: @parameters }
        )
      end

      @data_validator = context.inject(DataValidator)

      r.post do
        day_week = @parameters['day_week'].to_i
        num_lecture = @parameters['num_lecture'].to_i
        cabinet = @parameters['cabinet'].to_i
        lector = @parameters['lector']
        subject = @parameters['subject']
        groups = @parameters['groups'].strip.gsub(' ', '').split(',')

        begin
          @data_validator.validate_lector(lector)
          @data_validator.validate_cabinet(cabinet)
          @data_validator.validate_subject(subject)
          @data_validator.validate_groups(groups)

          lecture = Lecture.new(subject, cabinet, groups, lector)
          @service.add_lecture(day_week, num_lecture, lecture)

          r.redirect('list')
        rescue StandardError => e
          @parameters['error'] = e

          view(
            'add_lecture',
            locals: { parameters: @parameters }
          )
        end
      end
    end

    r.post 'remove' do
      day = r.params['day'].to_i
      num = r.params['num'].to_i
      cabinet = r.params['cabinet'].to_i

      lecture = @service.delete_lecture_by_time(day, num, cabinet)

      if lecture.nil?
        view('lecture_not_found')
      else
        view(
          'deleted_lecture',
          locals: { lecture: lecture }
        )
      end
    end
  end

  hash_branch('menu') do |r|
    r.on do
      view('menu')
    end
  end
end
