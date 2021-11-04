# frozen_string_literal: true

require 'stringio'
require 'tty/prompt/test'
require_relative '../../context'
require_relative '../../../lib/app/model/lecture'
require_relative '../../../lib/app/command/command_change_time'
require_relative '../../../lib/app/repository/scheduler_repository'
require_relative '../../../lib/api/exception/business_exception'

# Default description change it
RSpec.describe CommandChangeTime do
  let(:prompt) { TTY::Prompt::Test.new }
  let(:command) { context.instance(CommandChangeTime) }
  let(:repository) { context.instance(SchedulerRepository) }

  let(:context) do
    TestContext.new
               .bean(TTY::Prompt, prompt)
  end

  let(:lecture) do
    Lecture.new('Subject #', 107, %w[TM-1 TM-2], 'lector X')
  end

  let(:lecture_other) do
    Lecture.new('Subject ##', 107, %w[TM-3 TM-4], 'lector Y')
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

  it 'should change time' do
    repository.save_lecture(1, 2, lecture)

    expect(1).to eq(repository.scheduler.count)

    # 1 day, 2 lecture, first lecture, 3 day, 5 lecture, first lecture
    prompt.input << "\nd\n\ndd\ndddd\n"
    prompt.input.rewind

    before_change = repository.scheduler.first # [Lecture, day, num]
    expect(before_change[1]).to eq(1)
    expect(before_change[2]).to eq(2)

    command.execute

    expect(1).to eq(repository.scheduler.count)
    after_change = repository.scheduler.first # [Lecture, day, num]

    # Check changes
    expect(after_change[1]).to eq(3)
    expect(after_change[2]).to eq(5)

    # Check that don't changes other data
    expect(after_change[0]).to_not be_nil
    expect(after_change[0].lector).to eq(before_change[0].lector)
    expect(after_change[0].subject).to eq(before_change[0].subject)
    expect(after_change[0].cabinet).to eq(before_change[0].cabinet)
    expect(after_change[0].groups).to include('TM-1', 'TM-2')
  end

  it 'should change time' do
    repository.save_lecture(1, 2, lecture)
    repository.save_lecture(1, 3, lecture_other)

    expect(2).to eq(repository.scheduler.count)

    # 1 day, 2 lecture, first lecture, 1 day, 3 lecture, first lecture
    prompt.input << "\n" << 'd' << "\n" << "\n" << "\n" << 'dd' << "\n"
    prompt.input.rewind

    before_change = repository.scheduler.first # [Lecture, day, num]
    expect(before_change[1]).to eq(1)
    expect(before_change[2]).to eq(2)

    expect { command.execute }.to raise_error(BusinessException)

    expect(2).to eq(repository.scheduler.count)
    after_change = repository.scheduler.find do |l, _, _|
      lecture.lector.eql?(l.lector)
    end

    # Check rollback
    expect(after_change[1]).to eq(1)
    expect(after_change[2]).to eq(2)

    # Check that don't changes other data
    expect(after_change[0]).to_not be_nil
    expect(after_change[0].lector).to eq(before_change[0].lector)
    expect(after_change[0].subject).to eq(before_change[0].subject)
    expect(after_change[0].cabinet).to eq(before_change[0].cabinet)
    expect(after_change[0].groups).to include('TM-1', 'TM-2')
  end

  it 'should return no end session' do
    expect(command.end_session?).to eq(false)
  end
end
