require_relative '../../../lib/app/service/group_service'
require_relative '../../../lib/app/repository/scheduler_repository'
require_relative '../../../lib/app/model/lecture'

RSpec.describe GroupService do
  let(:context) do
    TestContext.new
               .bean(SchedulerRepository, double(SchedulerRepository.name))
  end

  let(:service) do
    context.instance(GroupService)
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

  it 'should return all groups from schedule' do
    groups = service.find_groups(scheduler)
    expect(groups).not_to be_nil
    expect(groups).to include('GR-1', 'GR-2', 'GR-3')
  end
end
