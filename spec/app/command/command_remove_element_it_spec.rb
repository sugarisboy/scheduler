# frozen_string_literal: true

require 'stringio'
require 'tty/prompt/test'
require_relative '../../context'
require_relative '../../../lib/app/model/lecture'
require_relative '../../../lib/app/command/command_remove_element'
require_relative '../../../lib/app/repository/scheduler_repository'

RSpec.describe CommandRemoveElement do
  let(:prompt) { TTY::Prompt::Test.new }
  let(:command) { context.instance(CommandRemoveElement) }
  let(:repository) { context.instance(SchedulerRepository) }

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

  let(:lecture) do
    Lecture.new('Subject #', 107, %w[TM-1 TM-2], 'lector X')
  end

  it 'should remove element from storage' do
    repository.save_lecture(1, 2, lecture)

    expect(1).to eq(repository.scheduler.count)

    # 1 day, 2 lecture, first lecture
    prompt.input << "\nd\n\n"
    prompt.input.rewind

    command.execute

    expect(repository.scheduler.count).to eq(0)
  end

  it 'should remove element from storage' do
    repository.save_lecture(1, 2, lecture)

    expect(1).to eq(repository.scheduler.count)

    # 1 day, 2 lecture, empty lecture list
    prompt.input << "\n\n"
    prompt.input.rewind

    expect { command.execute }.to raise_error(BusinessException)

    expect(repository.scheduler.count).to eq(1)
  end
end
