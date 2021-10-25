# frozen_string_literal: true

require 'stringio'
require 'tty/prompt/test'
require_relative '../../context'
require_relative '../../../lib/app/model/lecture'
require_relative '../../../lib/app/command/command_change_cabinet'
require_relative '../../../lib/app/repository/scheduler_repository'
require_relative '../../../lib/api/exception/business_exception'

RSpec.describe CommandChangeCabinet do
  let(:prompt) { TTY::Prompt::Test.new }
  let(:command) { context.instance(CommandChangeCabinet) }
  let(:repository) { context.instance(SchedulerRepository) }

  let(:context) do
    TestContext.new
               .bean(TTY::Prompt, prompt)
  end

  let(:lecture) do
    Lecture.new('Subject #', 107, %w[TM-1 TM-2], 'lector X')
  end

  let(:lecture_other) do
    Lecture.new('Subject ##', 108, %w[TM-3 TM-4], 'lector Y')
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

  it 'should change cabinet' do
    repository.save_lecture(1, 2, lecture)

    expect(1).to eq(repository.scheduler.count)

    # 1 day, 2 lecture, first lecture
    prompt.input << "\n" << 'd' << "\n" << "\n"
    prompt.input.rewind
    new_cabinet = 105

    before_change = repository.scheduler.first[0]
    expect(before_change.cabinet).to_not eq(new_cabinet)

    $stdin = StringIO.new("#{new_cabinet}\n")
    command.execute

    expect(1).to eq(repository.scheduler.count)
    after_change = repository.scheduler.first # [Lecture, day, num]
    expect(after_change[0]).to_not be_nil
    expect(after_change[0].lector).to eq(before_change.lector)
    expect(after_change[0].subject).to eq(before_change.subject)
    expect(after_change[0].cabinet).to eq(new_cabinet)
    expect(after_change[0].groups).to include('TM-1', 'TM-2')
    expect(after_change[1]).to eq(1)
    expect(after_change[2]).to eq(2)
  end

  it 'should try change cabinet and dont change because not valid' do
    repository.save_lecture(1, 2, lecture)
    repository.save_lecture(1, 2, lecture_other)

    expect(2).to eq(repository.scheduler.count)

    # 1 day, 2 lecture, first lecture
    prompt.input << "\n" << 'd' << "\n" << "\n"
    prompt.input.rewind

    old_cabinet = lecture.cabinet
    new_cabinet = lecture_other.cabinet

    before_change = repository.scheduler.first[0]
    expect(before_change.cabinet).to_not eq(new_cabinet)

    $stdin = StringIO.new("#{new_cabinet}\n")

    expect { command.execute }.to raise_error(BusinessException)

    expect(2).to eq(repository.scheduler.count)
    after_change = repository.scheduler.find do |l, _, _|
      lecture.lector.eql?(l.lector)
    end

    expect(after_change[0].cabinet).to_not eq(new_cabinet)
    expect(after_change[0].cabinet).to eq(old_cabinet)

    expect(after_change[0]).to_not be_nil
    expect(after_change[0].lector).to eq(before_change.lector)
    expect(after_change[0].subject).to eq(before_change.subject)
    expect(after_change[0].groups).to include('TM-1', 'TM-2')
    expect(after_change[1]).to eq(1)
    expect(after_change[2]).to eq(2)
  end

  it 'should return no end session' do
    expect(command.end_session?).to eq(false)
  end
end
