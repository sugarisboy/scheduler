# frozen_string_literal: true

require 'stringio'
require 'tty/prompt/test'
require_relative '../../context'
require_relative '../../../lib/app/model/lecture'
require_relative '../../../lib/app/command/command_print_criteria'
require_relative '../../../lib/app/repository/scheduler_repository'
require_relative '../../../lib/api/exception/business_exception'

RSpec.describe CommandPrintCriteria do
  let(:prompt) { TTY::Prompt::Test.new }
  let(:command) { context.instance(CommandPrintCriteria) }
  let(:repository) { context.instance(SchedulerRepository) }

  let(:context) do
    TestContext.new
               .bean(TTY::Prompt, prompt)
  end

  before do
    prompt.on :keypress do |e|
      prompt.trigger :keyup if e.value == 'u'
      prompt.trigger :keydown if e.value == 'd'
      prompt.trigger :keyspace if e.value == 's'
    end
  end

  let(:lecture1) do
    Lecture.new('Subject 1', 106, %w[TM-1 TM-2], 'lector X')
  end

  let(:lecture2) do
    Lecture.new('Subject 2', 107, %w[TM-2 TM-3], 'lector Y')
  end

  let(:simple) do
    [
      /.*106\s*│\s*Subject 1\s*│\s*lector X\s*│\s*TM-1,TM-2.*/,
      /.*107\s*│\s*Subject 2\s*│\s*lector Y\s*│\s*TM-3,TM-4.*/
    ]
  end

  after do
    $stdin = STDIN
  end

  [
    # Тест по лектору
    ["\n", "lector X\n", /.*106\s*│/, /.*107\s*│/],
    ["\n", "lector Y\n", /.*107\s*│/, /.*106\s*│/],
    # Тест по группе
    ["d\n", "TM-1\n", /.*106\s*│/, /.*107\s*│/],
    ["d\n", "TM-2\n", /.*106\s*│/, nil],
    ["d\n", "TM-2\n", /.*107\s*│/, nil],
    ["d\n", "TM-3\n", /.*107\s*│/, /.*106\s*│/],
    # Тест по кабинету
    ["dd\n", "106\n", /.*106\s*│/, /.*107\s*│/],
    ["dd\n", "107\n", /.*107\s*│/, /.*106\s*│/],
    ["dd\n", "108\n", nil, /.*106\s*│/],
    # Тест по времени
    ["ddd\n\nd\n", 'not used', /.*106\s*│/, /.*107\s*│/],
    ["ddd\ndd\ndddd\n", 'not used', /.*107\s*│/, /.*106\s*│/]
  ].each do |prompt_input, line_input, include, exclude|
    it 'Should print by criteria' do
      repository.save_lecture(1, 2, lecture1)
      repository.save_lecture(3, 5, lecture2)

      prompt.input << (prompt_input * 2)
      prompt.input.rewind

      $stdin = StringIO.new(line_input * 2)

      unless include.nil?
        expect { command.execute }.to output(include).to_stdout
      end

      unless exclude.nil?
        expect { command.execute }.to_not output(exclude).to_stdout
      end
    end
  end

  it 'should return no end session' do
    expect(command.end_session?).to eq(false)
  end
end
