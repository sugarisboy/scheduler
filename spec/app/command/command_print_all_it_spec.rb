# frozen_string_literal: true

require 'stringio'
require 'tty/prompt/test'
require_relative '../../context'
require_relative '../../../lib/app/model/lecture'
require_relative '../../../lib/app/command/command_print_all'
require_relative '../../../lib/app/repository/scheduler_repository'
require_relative '../../../lib/api/exception/business_exception'

# Default description change it
RSpec.describe CommandPrintAll do
  let(:prompt) { TTY::Prompt::Test.new }
  let(:command) { context.instance(CommandPrintAll) }
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

  after do
    $stdin = STDIN
  end

  it 'should print all lectures with one lecture' do
    repository.save_lecture(1, 2, lecture2)

    expected = /.*107\s*│\s*Subject 2\s*│\s*lector Y\s*│\s*TM-3,TM-4.*/
    expect { command.execute }.to output(expected).to_stdout
  end

  [
    /.*107\s*│\s*Subject 2\s*│\s*lector Y\s*│\s*TM-3,TM-4.*/,
    /.*106\s*│\s*Subject 1\s*│\s*lector X\s*│\s*TM-1,TM-2.*/,
  ].each do |line|
    it 'should print all lectures many lectures' do
      repository.save_lecture(1, 2, lecture1)
      repository.save_lecture(3, 4, lecture2)
    end
  end

  it 'should return no end session' do
    expect(command.end_session?).to eq(false)
  end
end
