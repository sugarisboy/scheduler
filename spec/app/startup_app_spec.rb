# frozen_string_literal: true

require 'stringio'
require 'tty/prompt/test'
require_relative '../context'
require_relative '../../lib/scheduler_app'

# Default description change it
RSpec.describe SchedulerApp do
  let(:prompt) { TTY::Prompt::Test.new }

  let(:context) do
    TestContext.new
               .bean(TTY::Prompt, prompt)
  end

  before do
    prompt.on :keypress do |e|
      prompt.trigger :keyup if e.value == 'u'
      prompt.trigger :keydown if e.value == 'd'
    end
  end

=begin
     it 'Should startup application' do
    # 7 Раз вниз и выход из приложения
    prompt.input << 'd' << 'd' << 'd' << 'd' << 'd' << 'd' << 'd' << 'd' << "\n"
    prompt.input.rewind
    app = SchedulerApp.new(context)
    expect(app).to_not be_nil
     end
=end
end
