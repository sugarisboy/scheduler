# frozen_string_literal: true

require_relative '../../../lib/app/service/scheduler_service'
require_relative '../../../lib/app/service/lector_service'
require_relative '../../../lib/app/repository/scheduler_repository'
require_relative '../../../lib/app/validators/business_validator'
require_relative '../../../lib/app/model/lecture'
require_relative '../../../lib/app/repository/scheduler_query'

RSpec.describe SchedulerService do
  let(:context) do
    TestContext.new
               .bean(SchedulerRepository, double(SchedulerRepository.name))
               .bean(LectorService, double(LectorService.name))
               .bean(BusinessValidator, double(BusinessValidator.name))
  end

  let(:service) do
    context.instance(SchedulerService)
  end

  let(:lecture) do
    Lecture.new('Subject #', 107, %w[TM-1 TM-2], 'lector X')
  end

  before(:each) do
    repository = context.inject(SchedulerRepository)
    allow(repository).to receive(:find_all_lectures).and_return(query_builder)
  end

  let(:query_builder) do
    builder = double(SchedulerQuery.name)
    allow(builder).to receive(:day_week).and_return(builder)
    allow(builder).to receive(:num_lecture).and_return(builder)
    allow(builder).to receive(:result).and_return(double)
    builder
  end

  it 'Should add lecture in storage' do
    repository = context.inject(SchedulerRepository)
    allow(repository).to receive(:save_lecture).with(1, 2, lecture)
                                               .and_return(lecture)

    validator = context.inject(BusinessValidator)
    allow(validator).to receive(:check_is_free_group)
    allow(validator).to receive(:check_is_free_lector)
    allow(validator).to receive(:check_is_free_cabinet)
    allow(validator).to receive(:check_workload_lector)
      .with(['subject'], lecture.lector)

    lector_service = context.inject(LectorService)
    allow(lector_service).to receive(:find_subjects).with(lecture.lector)
                                                    .and_return(['subject'])

    result = service.add_lecture(1, 2, lecture)
    expect(result).to be(lecture)
  end

  %i[
    check_is_free_group
    check_is_free_lector
    check_is_free_cabinet
    check_workload_lector
    check_workload_lector
  ].each do |method|
    it 'Should throw exception with not valid lecture for add in storage' do
      repository = context.inject(SchedulerRepository)
      allow(repository).to receive(:save_lecture).with(1, 2, lecture)
                                                 .and_return(lecture)

      validator = context.inject(BusinessValidator)
      allow(validator).to receive(:check_is_free_group)
      allow(validator).to receive(:check_is_free_lector)
      allow(validator).to receive(:check_is_free_cabinet)
      allow(validator).to receive(:check_workload_lector)
        .with(['subject'], lecture.lector)

      allow(validator).to receive(method).and_raise(ValidationException)

      lector_service = context.inject(LectorService)
      allow(lector_service).to receive(:find_subjects).with(lecture.lector)
                                                      .and_return(['subject'])

      expect { service.add_lecture(1, 2, lecture) }.to(
        raise_error(ValidationException)
      )
      expect(repository).not_to receive(:save_lecture)
    end
  end

  it 'should delete lecture from storage' do
    info = { day_week: 1, num_lecture: 2, lecture: lecture }
    repository = context.inject(SchedulerRepository)
    allow(repository).to receive(:find_lecture).with(lecture, extend: true)
                                               .and_return(info)
    allow(repository).to receive(:delete_lecture).with(1, 2, lecture)
                                                 .and_return(lecture)

    result = service.delete_lecture(lecture)
    expect(info).to eq(result)
  end

  it 'should delete non exist lecture and raise error' do
    repository = context.inject(SchedulerRepository)
    allow(repository).to receive(:find_lecture).and_return(nil)

    expect { service.delete_lecture(lecture) }.to raise_error(RuntimeError)

    expect(repository).not_to receive(:delete_lecture)
  end

  it 'should raise error when cant delete' do
    info = { day_week: 1, num_lecture: 2, lecture: lecture }

    repository = context.inject(SchedulerRepository)
    allow(repository).to receive(:find_lecture).and_return(info)
    allow(repository).to receive(:delete_lecture).and_return(nil)

    expect { service.delete_lecture(lecture) }.to raise_error(RuntimeError)
  end

  it 'should return scheduler instance' do
    scheduler = double

    repository = context.inject(SchedulerRepository)
    allow(repository).to receive(:scheduler).and_return(scheduler)

    result = service.find

    expect(scheduler).to eq(result)
  end

  it 'should return all lectures by group in' do
    group = 'TMP-1'
    allow(query_builder).to receive(:groups_in).with(group)
                                               .and_return(query_builder)

    result = service.find_by_group(group)
    expect(result).to_not be_nil
  end

  it 'should return all lectures by time' do
    day_week = 1
    num_lecture = 3
    allow(query_builder).to receive(:day_week).with(day_week)
                                              .and_return(query_builder)
    allow(query_builder).to receive(:num_lecture).with(num_lecture)
                                                 .and_return(query_builder)

    result = service.lectures_by_time(day_week, num_lecture)
    expect(result).to_not be_nil
  end

  it 'should return all lectures by any group' do
    groups = %w[TMP-1 TMP-2]
    allow(query_builder).to receive(:groups_any).with(groups)
                                                .and_return(query_builder)

    result = service.find_by_any_groups(groups)
    expect(result).to_not be_nil
  end

  it 'should return all lectures by lector' do
    lector = 'lector_example'
    allow(query_builder).to receive(:lector).with(lector)
                                            .and_return(query_builder)

    result = service.find_by_lector(lector)
    expect(result).to_not be_nil
  end

  it 'should return all lectures by cabinet' do
    cabinet = 707
    allow(query_builder).to receive(:cabinet).with(cabinet)
                                             .and_return(query_builder)

    result = service.find_by_cabinet(cabinet)
    expect(result).to_not be_nil
  end
end
