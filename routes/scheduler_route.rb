# frozen_string_literal: true

# Retake route
class SchedulerWebApp
  hash_branch('scheduler') do |r|
    append_view_subdir('scheduler')
    set_layout_options(template: '../views/layout')

    @wrapper = opts[:wrapper]

    # Main code
    context = opts[:app].context
    @service = context.inject(SchedulerService)
    @group_service = context.inject(GroupService)
    @lector_service = context.inject(LectorService)

    r.is('view_all') { view_all(r) }
    r.is('create') { create(r) }
    r.is('save') { save(r) }
    r.post('delete') { delete(r) }
    r.is('change_time') { change_time(r) }
  end

  def view_all(req)
    @params = DryResultFormeAdapter.new(FilterLectureScheme.call(req.params))

    @scheduler = @service.find_by_filters(
      @params[:lector],
      @params[:cabinet],
      @params[:group]
    )
    @day_names = @wrapper.day_names
    @lectors = @wrapper.find_all_lectors
    @groups = @wrapper.find_all_groups

    view('lectures_list')
  end

  def create(req)
    @day_names = @wrapper.day_names
    @params = {}

    req.post do
      @params = DryResultFormeAdapter.new(AddLectureScheme.call(req.params))

      if @params.success?
        @response = @wrapper.create_lecture(
          @params[:day_week], @params[:num_lecture], @params[:cabinet],
          @params[:lector], @params[:subject], @params[:groups]
        )

        req.redirect('view_all') if @response[:created]
      end

      view('create_lecture')
    end

    view('create_lecture')
  end

  def delete(req)
    day = req.params['day'].to_i
    num = req.params['num'].to_i
    cabinet = req.params['cabinet'].to_i

    @deleted = @wrapper.delete_lecture(day, num, cabinet)

    if @deleted.nil?
      view('lecture_not_found')
    else
      view('deleted_lecture')
    end
  end

  def change_time(req)
    @params = {}
    @lecture = @wrapper.find_by_time(
      @params[:old_day_week], @params[:old_num_lecture], @params[:old_cabinet]
    )
    @day_names = @wrapper.day_names

    req.post do
      @params = DryResultFormeAdapter.new(MoveLectureSchema.call(req.params))
      change_time_handle(req, @params)
    end

    view('move_lecture')
  end

  def change_time_handle(req, params)
    view('move_lecture') unless params.success?

    @response = opts[:wrapper].move_lecture(
      params[:old_day_week], params[:new_day_week],
      params[:old_num_lecture], params[:new_num_lecture],
      params[:old_cabinet], params[:new_cabinet]
    )

    if @response[:updated]
      req.redirect('view_all')
    else
      view('move_lecture')
    end
  end

  def save(req)
    req.get do
      view('save_submit')
    end

    req.post do
      @wrapper.save_changes
      req.redirect('/menu')
    end
  end
end
