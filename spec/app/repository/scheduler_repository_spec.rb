require_relative '../../context'
require_relative '../../../lib/app/repository/scheduler_query'
require_relative '../../../lib/app/repository/scheduler_repository'
require_relative '../../../lib/app/validators/data_validator'
require_relative '../../../lib/api/exception/validation_exception'

RSpec.describe SchedulerRepository do
  let(:context) do
    TestContext.new
               .bean(DataValidator, double(DataValidator.name))
  end

  let(:repository) do
    context.instance(SchedulerRepository)
  end

  before(:each) do
    validator = context.inject(DataValidator)
    allow(validator).to receive(:validate_day_week).and_return(nil)
    allow(validator).to receive(:validate_num_lecture).and_return(nil)
  end

  it 'should save lecture in storage' do
    day_week = 1
    num_lecture = 3
    lecture = Lecture.new('Subject', 101, %w[GR-1 GR-2], 'lector')
    repository.save_lecture(day_week, num_lecture, lecture)

    saved_info = repository.find_lecture(lecture, extend: true)
    expect(saved_info[:day_week]).to eq(day_week)
    expect(saved_info[:num_lecture]).to eq(num_lecture)
    expect(saved_info[:instance]).to eq(lecture)
  end

  it 'should save with validate num lecture exception in storage' do
    validator = context.inject(DataValidator)
    allow(validator).to receive(:validate_num_lecture)
                          .and_raise(ValidationException)

    day_week = 1
    num_lecture = 3
    lecture = Lecture.new('Subject', 101, %w[GR-1 GR-2], 'lector')

    exception = expect do
      repository.save_lecture(day_week, num_lecture, lecture)
    end
    exception.to raise_error(ValidationException)

    saved_info = repository.find_lecture(lecture)
    expect(saved_info).to be_nil
  end

  it 'should save with validate day week exception in storage' do
    validator = context.inject(DataValidator)
    allow(validator).to receive(:validate_day_week)
                          .and_raise(ValidationException)

    day_week = 1
    num_lecture = 3
    lecture = Lecture.new('Subject', 101, %w[GR-1 GR-2], 'lector')

    exception = expect do
      repository.save_lecture(day_week, num_lecture, lecture)
    end
    exception.to raise_error(ValidationException)

    saved_info = repository.find_lecture(lecture)
    expect(saved_info).to be_nil
  end

  it 'should return builder for find all lectures' do
    query = repository.find_all_lectures
    expect(query).to be_kind_of(SchedulerQuery)
  end

  it 'should find by criteria' do
    day_week = 1
    num_lecture = 3
    lecture = Lecture.new('Subject', 101, %w[GR-1 GR-2], 'lector')
    repository.save_lecture(day_week, num_lecture, lecture)

    criteria = [
      Proc.new { |_lecture, day, _num| day == 1 },
      Proc.new { |_lecture, _day, num| num == 3 },
      Proc.new { |lecture, _day, _num| lecture.cabinet == 101 }
    ]

    query_result = repository.find_by_criteria(criteria).first
    expect(query_result[0]).to eq(lecture)
  end

  it 'should delete exists lecture' do
    day_week = 1
    num_lecture = 3
    lecture = Lecture.new('Subject', 101, %w[GR-1 GR-2], 'lector')
    repository.save_lecture(day_week, num_lecture, lecture)
    repository.delete_lecture(day_week, num_lecture, lecture)
    deleted_info = repository.find_lecture(lecture)
    expect(deleted_info).to be_nil
  end
end