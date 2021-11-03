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

  it 'Should print ' do
    service.print_all(scheduler)
  end
end
