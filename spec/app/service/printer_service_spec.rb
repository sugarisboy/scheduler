require_relative '../../context'
require_relative '../../../lib/app/service/printer_service'
require_relative '../../../lib/app/repository/scheduler_repository'
require_relative '../../../lib/app/model/lecture'

RSpec.describe PrinterService do
  let(:context) do
    TestContext.new
               .bean(SchedulerRepository, double(SchedulerRepository.name))
  end

  let(:service) do
    context.instance(PrinterService)
  end

  let(:scheduler) do
    scheduler = Scheduler.new
    lecture1 = Lecture.new('Subject 1', 101, %w[GR-1 GR-2], 'lector1')
    lecture2 = Lecture.new('Subject 2', 101, %w[GR-1 GR-2], 'lector2')
    lecture3 = Lecture.new('Subject 3', 102, %w[GR-3 GR-2], 'lector1')
    scheduler.data[1].data[2] << lecture1
    scheduler.data[3].data[4] << lecture2
    scheduler.data[5].data[6] << lecture3
    scheduler
  end

  let(:expected) do
    monday +
      "\e[32m================================= Вторник ==" \
      "===============================\e[0m\n" \
      "\e[32m================================= Среда ====" \
      "=============================\e[0m\n" \
      "\e[36m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 4 пары ━" \
      "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\e[0m\n" \
      "\e[36m  каб │                              Дисципл" \
      "ина │       Преподаватель │Группы\e[0m\n" \
      "  101 │                               Subject 2 │ " \
      "            lector2 │GR-1,GR-2\n" \
      "\e[32m================================= Четверг ==" \
      "===============================\e[0m\n" \
      "\e[32m================================= Пятница ==" \
      "===============================\e[0m\n" \
      "\e[36m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 6 пары ━" \
      "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\e[0m\n" \
      "\e[36m  каб │                              Дисципл" \
      "ина │       Преподаватель │Группы\e[0m\n" \
      "  102 │                               Subject 3 │ " \
      "            lector1 │GR-3,GR-2\n" \
      "\e[32m================================= Суббота ==" \
      "===============================\e[0m\n"
  end

  let(:monday) do
    "\e[32m================================= Понедельник =" \
      "================================\e[0m\n" \
      "\e[36m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 2 пары ━━" \
      "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\e[0m\n" \
      "\e[36m  каб │                              Дисципли" \
      "на │       Преподаватель │Группы\e[0m\n" \
      "  101 │                               Subject 1 │  " \
      "           lector1 │GR-1,GR-2\n"
  end

  it 'Should print all' do
    expect { service.print_all(scheduler) }.to output(expected).to_stdout
  end

  it 'Should print day' do
    expect { service.print_day(1, scheduler.data[1]) }.to output(monday).to_stdout
  end

  [
    [1, 'Понедельник'],
    [2, 'Вторник'],
    [3, 'Среда'],
    [4, 'Четверг'],
    [5, 'Пятница'],
    [6, 'Суббота']
  ].each do |day_week, expected|
    it 'should format week day number to day name' do
      result = service.format_day(day_week)
      expect(expected).to eq(result)
    end
  end

  it 'should format week day with non exist number to day name' do
    result = service.format_day(10)
    expect(nil).to eq(result)
  end
end
