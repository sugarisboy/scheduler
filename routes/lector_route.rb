# frozen_string_literal: true

# Retake route
class SchedulerWebApp
  hash_branch('lector') do |r|
    append_view_subdir('lector')
    set_layout_options(template: '../views/layout')
    @wrapper = opts[:wrapper]

    # Main code

    r.get 'workload' do
      workload(r)
    end
  end

  def workload(req)
    @params = DryResultFormeAdapter.new(LectorWorkloadScheme.call(req.params))

    @lectors = @wrapper.find_all_lectors
    @workload = @wrapper.find_workload(@params[:lector]) if @params.success?

    view('lector_workload')
  end
end
