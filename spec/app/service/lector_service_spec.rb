# frozen_string_literal: true

require_relative '../../../lib/app/service/lector_service'
require_relative '../../../lib/app/repository/scheduler_repository'
require_relative '../../../lib/app/model/lecture'

RSpec.describe LectorService do
  let(:context) do
    TestContext.new
               .bean(SchedulerRepository, SchedulerRepository.new(scheduler))
  end

  let(:service) do
    context.instance(LectorService)
  end

  let(:scheduler) do
    scheduler = Scheduler.new
    lecture1 = Lecture.new('Subject 1', 103, %w[GR-1 GR-2], 'lector1')
    lecture2 = Lecture.new('Subject 2', 101, %w[GR-1 GR-2], 'lector2')
    lecture3 = Lecture.new('Subject 3', 102, %w[GR-3 GR-2], 'lector1')
    scheduler.data[1].data[2] << lecture1
    scheduler.data[3].data[4] << lecture2
    scheduler.data[5].data[6] << lecture3
    scheduler
  end

  it 'should return all lectures from schedule by lector' do
    lectures = service.find_lectures('lector1')
    expect(lectures).not_to be_nil
    expect(lectures.count).to eq(2)
  end

  it 'should return all lectors from schedule' do
    lectors = service.find_lectors(scheduler)
    expect(lectors).not_to be_nil
    expect(lectors).to include('lector1', 'lector2')
  end

  it 'should return all groups from schedule by lector' do
    groups = service.find_groups('lector1')
    expect(groups).not_to be_nil
    expect(groups).to include('GR-1', 'GR-2', 'GR-3')
  end

  it 'should return all subjects from schedule by lector' do
    subjects = service.find_subjects('lector1')
    expect(subjects).not_to be_nil
    expect(subjects).to include('Subject 1', 'Subject 3')
  end

  it 'should return all cabinets from schedule by lector' do
    cabinets = service.find_cabinets('lector1')
    expect(cabinets).not_to be_nil
    expect(cabinets).to include(103, 102)
  end
end
