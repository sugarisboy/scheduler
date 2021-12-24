# frozen_string_literal: true

require_relative '../../../lib/app/model/lecture'
require_relative '../../../lib/app/model/day_scheduler'

RSpec.describe DayScheduler do
  it 'should_return_sorted_data' do
    day = DayScheduler.new
    day.data[1] << Lecture.new('test', 101, 'test', 'test')
    day.data[1] << Lecture.new('test', 102, 'test', 'test')
    day.data[1] << Lecture.new('test', 103, 'test', 'test')

    sorted = day.sorted_data
    first_lecture_sorted = sorted[1]
    expect(first_lecture_sorted[0].cabinet).to eq(101)
    expect(first_lecture_sorted[1].cabinet).to eq(102)
    expect(first_lecture_sorted[2].cabinet).to eq(103)
  end
end
