# frozen_string_literal: true

require_relative '../context'
require_relative '../../lib/scheduler_app'

RSpec.describe SchedulerApp do
  let(:context) do
    TestContext.new
  end

  it 'Should startup application' do
    app = SchedulerApp.new(context)
    expect(app).to_not be_nil
  end
end
