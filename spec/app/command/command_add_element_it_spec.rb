# frozen_string_literal: true

require 'stringio'
require 'tty/prompt/test'
require_relative '../../context'
require_relative '../../../lib/app/command/command_add_element'
require_relative '../../../lib/api/exception/business_exception'
require_relative '../../../lib/app/repository/scheduler_repository'

# Default description change it
RSpec.describe CommandAddElement do
  let(:prompt) { TTY::Prompt::Test.new }
  let(:command) { context.instance(CommandAddElement) }
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

  it 'should add element' do
    expect(0).to eq(repository.scheduler.count)

    prompt.input << 'd' << 'd' << "\n" << 'd' << 'd' << 'd' << 'd' << "\n"
    prompt.input.rewind
    groups = 'GR-1, GR-2'
    lector = 'lector'
    subject = 'subject'
    cabinet = '104'
    $stdin = StringIO.new("#{groups}\n#{lector}\n#{subject}\n#{cabinet}\n")
    command.execute

    expect(1).to eq(repository.scheduler.count)
    saved = repository.scheduler.first # [Lecture, day, num]
    expect(saved[0]).to_not be_nil
    expect(saved[0].lector).to eq(lector)
    expect(saved[0].subject).to eq(subject)
    expect(saved[0].cabinet).to eq(104)
    expect(saved[0].groups).to include('GR-1', 'GR-2')
    expect(saved[1]).to eq(3)
    expect(saved[2]).to eq(5)
  end

  it 'should add element with error' do
    expect(0).to eq(repository.scheduler.count)

    prompt.input << 'd' << 'd' << "\n" << 'd' << 'd' << 'd' << 'd' << "\n"
    prompt.input.rewind
    groups = 'GR-1, GR-2'
    lector = 'lector'
    subject = 'subject'
    cabinet = '104'
    input = "#{groups}\n#{lector}\n#{subject}\n#{cabinet}a\n#{cabinet}\n"
    $stdin = StringIO.new(input)
    command.execute

    expect(1).to eq(repository.scheduler.count)
    saved = repository.scheduler.first # [Lecture, day, num]
    expect(saved[0]).to_not be_nil
    expect(saved[0].lector).to eq(lector)
    expect(saved[0].subject).to eq(subject)
    expect(saved[0].cabinet).to eq(104)
    expect(saved[0].groups).to include('GR-1', 'GR-2')
    expect(saved[1]).to eq(3)
    expect(saved[2]).to eq(5)
  end

  it 'should add element when group busy' do
    repository.save_lecture(3, 5, Lecture.new('#', 707, ['GR-2'], '#'))
    expect(1).to eq(repository.scheduler.count)

    prompt.input << 'd' << 'd' << "\n" << 'd' << 'd' << 'd' << 'd' << "\n"
    prompt.input.rewind
    groups = 'GR-1, GR-2'
    lector = 'lector'
    subject = 'subject'
    cabinet = '104'
    $stdin = StringIO.new("#{groups}\n#{lector}\n#{subject}\n#{cabinet}\n")

    expect { command.execute }.to raise_error(
      BusinessException,
      'Группы GR-2 заняты в это время'
    )
  end

  it 'should add element when lector busy' do
    repository.save_lecture(3, 5, Lecture.new('#', 707, ['#'], 'lector'))
    expect(1).to eq(repository.scheduler.count)

    prompt.input << 'd' << 'd' << "\n" << 'd' << 'd' << 'd' << 'd' << "\n"
    prompt.input.rewind
    groups = 'GR-1, GR-2'
    lector = 'lector'
    subject = 'subject'
    cabinet = '104'
    $stdin = StringIO.new("#{groups}\n#{lector}\n#{subject}\n#{cabinet}\n")

    expect { command.execute }.to raise_error(
      BusinessException,
      'Лектор lector занят в это время'
    )
  end

  it 'should return no end session' do
    expect(command.end_session?).to eq(false)
  end
end
