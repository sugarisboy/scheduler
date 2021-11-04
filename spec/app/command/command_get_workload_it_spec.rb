# frozen_string_literal: true

require 'stringio'
require 'tty/prompt/test'
require_relative '../../context'
require_relative '../../../lib/app/model/lecture'
require_relative '../../../lib/app/command/command_get_workload'
require_relative '../../../lib/app/repository/scheduler_repository'
require_relative '../../../lib/api/exception/business_exception'

RSpec.describe CommandGetWorkload do
  let(:prompt) { TTY::Prompt::Test.new }
  let(:command) { context.instance(CommandGetWorkload) }
  let(:repository) { context.instance(SchedulerRepository) }

  let(:context) do
    TestContext.new
               .bean(TTY::Prompt, prompt)
  end

  let(:lecture1) do
    Lecture.new('Subject 1', 106, %w[TM-1 TM-2], 'lector X')
  end

  let(:lecture2) do
    Lecture.new('Subject 2', 107, %w[TM-3 TM-4], 'lector Y')
  end

  let(:lecture3) do
    Lecture.new('Subject 3', 108, %w[TM-3 TM-2], 'lector X')
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

  [
    /.*Количество лекций в неделю: 2.*/,
    /.*Список связанных дисциплин: Subject 1, Subject 3.*/,
    /.*Список связанных групп: TM-1, TM-2, TM-3.*/
  ].each do |expected|
    it "should get workload: #{expected}" do
      repository.save_lecture(1, 2, lecture1)
      repository.save_lecture(2, 3, lecture2)
      repository.save_lecture(3, 4, lecture3)

      prompt.input << "\n"
      prompt.input.rewind

      expect { command.execute }.to output(expected).to_stdout
    end
  end

  it 'should return no end session' do
    expect(command.end_session?).to eq(false)
  end
end
