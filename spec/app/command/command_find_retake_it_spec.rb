# frozen_string_literal: true

require 'stringio'
require 'tty/prompt/test'
require_relative '../../context'
require_relative '../../../lib/app/model/lecture'
require_relative '../../../lib/app/command/command_find_retake'
require_relative '../../../lib/app/repository/scheduler_repository'
require_relative '../../../lib/api/exception/business_exception'

# Default description change it
RSpec.describe CommandChangeTime do
  let(:prompt) { TTY::Prompt::Test.new }
  let(:command) { context.instance(CommandFindRetake) }
  let(:repository) { context.instance(SchedulerRepository) }

  let(:context) do
    TestContext.new
               .bean(TTY::Prompt, prompt)
  end

  let(:lecture) do
    Lecture.new('Subject #', 107, %w[TM-1 TM-2], 'lector X')
  end

  before do
    prompt.on :keypress do |e|
      prompt.trigger :keyup if e.value == 'u'
      prompt.trigger :keydown if e.value == 'd'
      prompt.trigger :keyspace if e.value == 's'
    end
  end

  after do
    $stdin = STDIN
  end

  it 'should success find retake time' do
    repository.save_lecture(1, 2, lecture)

    expect(1).to eq(repository.scheduler.count)

    # first group, first service
    prompt.input << "s\n\n"
    prompt.input.rewind

    expect_str = /.*Результат: Понедельник, 3, 4 пара, 107 кабинет.*/
    expect { command.execute }.to output(expect_str).to_stdout
  end

  it 'should failed find retake time' do
    (1..6).each do |day|
      (1..6).each { |num| repository.save_lecture(day, num, lecture) }
    end

    expect(6 * 6).to eq(repository.scheduler.count)

    # first group, first service
    prompt.input << "s\n\n"
    prompt.input.rewind

    expect_str = /.*Время для пересдачи не удалось найти.*/
    expect { command.execute }.to output(expect_str).to_stdout
  end

  it 'should return no end session' do
    expect(command.end_session?).to eq(false)
  end
end
