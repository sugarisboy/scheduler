# frozen_string_literal: true

require 'stringio'
require 'tty/prompt/test'
require_relative '../../context'
require_relative '../../../lib/app/command/command_exit'

# Default description change it
RSpec.describe CommandExit do
  let(:prompt) { TTY::Prompt::Test.new }
  let(:command) { context.instance(CommandExit) }

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

  after do
    $stdin = STDIN
  end

  it 'should exit from app' do
    prompt.input << "\n"
    prompt.input.rewind

    expect(command.end_session?).to eq(true)
    expect { command.execute }.to raise_error(NotImplementedError)
  end
end
