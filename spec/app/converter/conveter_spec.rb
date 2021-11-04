# frozen_string_literal: true

require 'tempfile'
require_relative '../../../lib/app/config/env_config'
require_relative '../../../lib/app/converter/model_file_converter'

# Default description change it
RSpec.describe ModelFileConverter do
  let(:converter) { context.instance(ModelFileConverter) }
  let(:repository) { context.inject(SchedulerRepository) }
  let(:envs) { context.inject(EnvConfig) }
  let(:context) { TestContext.new }

  let(:scheduler) do
    scheduler = Scheduler.new
    lecture1 = Lecture.new('Subject 1', 101, %w[GR-1 GR-2], 'lector1')
    scheduler.data[1].data[2] << lecture1
    lecture2 = Lecture.new('Subject 2', 101, %w[GR-1 GR-2], 'lector2')
    scheduler.data[3].data[4] << lecture2
    lecture3 = Lecture.new('Subject 3', 102, %w[GR-3 GR-2], 'lector1')
    scheduler.data[5].data[6] << lecture3
    scheduler
  end

  it 'should read and write' do
    envs.data_dir = '../../../spec/data'
    envs.file = 'data_in.csv'

    converter.read

    scheduler = repository.scheduler
    count = scheduler.count
    expect(count).to_not eq(0)
    envs.file = 'data_out.csv'

    converter.write(scheduler)

    writed_count = IOUtils.read_csv("#{envs.data_dir}/#{envs.file}", ';').count
    expect(writed_count).to eq(count)

    # clear file after test
    IOUtils.write_csv("#{envs.data_dir}/#{envs.file}", ';', [])
  end
end
