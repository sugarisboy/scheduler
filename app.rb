# frozen_string_literal: true

require 'roda'

require_relative 'models'
require_relative 'lib/scheduler_app'
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

    context = opts[:app].context
    @service = context.inject(SchedulerService)
    @group_service = context.inject(GroupService)
    @lector_service = context.inject(LectorService)

    r.get 'list' do
      @params = DryResultFormeAdapter.new(FilterLectureScheme.call(r.params))

      @scheduler = @service.find_by_filters(
        @params[:lector],
        @params[:cabinet],
        @params[:group]
      )
      @lectors = @lector_service.find_lectors
      @groups = @group_service.find_groups

      view('lectures_list')
    end

    r.on 'add' do
      @params = DryResultFormeAdapter.new(AddLectureScheme.call(r.params))

      r.get do
        view('add_lecture')
      end

      r.post do
        day_week = @params[:day_week].to_i
        num_lecture = @params[:num_lecture].to_i
        cabinet = @params[:cabinet].to_i
        lector = @params[:lector]
        subject = @params[:subject]
        groups = @params[:groups].strip.gsub(' ', '').split(',')

        if @params.success?
          begin
            lecture = Lecture.new(subject, cabinet, groups, lector)
            @service.add_lecture(day_week, num_lecture, lecture)

            r.redirect('list')
          rescue StandardError => e
            @business_error = e
            view('add_lecture')
          end
        else
          view('add_lecture')
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
