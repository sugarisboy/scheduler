# frozen_string_literal: true

require_relative '../../../lib/api/context'
require_relative '../../../lib/app/service/lector_service'
require_relative '../../../lib/app/repository/scheduler_repository'
require_relative '../../utils'

RSpec.describe LectorService do
  let(:service) { context.instance(LectorService) }

  let(:context) do
    TestContext.new
               .bean(SchedulerRepository,double(SchedulerRepository.name))
  end

  it 'Simple-Dimple test' do
    expect(service.simple).to eq('dimple')
  end

  it 'Simple-Just-Do-It test' do
    repository = context.inject(SchedulerRepository)
    allow(repository).to receive(:just).and_return('no do it!')
    expect(service.simple2).to eq('no do it!')
  end
end
