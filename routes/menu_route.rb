# frozen_string_literal: true

# Retake route
class SchedulerWebApp
  hash_branch('menu') do |r|
    append_view_subdir('menu')
    set_layout_options(template: '../views/layout')
    @wrapper = opts[:wrapper]

    # Main code

    r.is do
      view('menu')
    end
  end
end
