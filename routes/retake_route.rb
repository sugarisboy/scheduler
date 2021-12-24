# frozen_string_literal: true

# Retake route
class SchedulerWebApp
  hash_branch('retake') do |r|
    append_view_subdir('retake')
    set_layout_options(template: '../views/layout')
    wrapper = opts[:wrapper]

    # Main code

    @lectors = wrapper.find_all_lectors
    @params = DryResultFormeAdapter.new(FindRetakeScheme.call(r.params))

    r.get do
      if @params.success?
        @retake = wrapper.search_retakes(@params[:lector], @params[:groups])
      end

      view('retake_info')
    end
  end
end
