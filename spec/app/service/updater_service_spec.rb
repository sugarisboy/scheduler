require_relative '../../../lib/app/model/lecture'
require_relative '../../../lib/app/service/updater_service'
require_relative '../../../lib/app/service/scheduler_service'
require_relative '../../../lib/api/exception/business_exception'

RSpec.describe UpdaterService do
  let(:context) do
    TestContext.new
               .bean(SchedulerService, double(SchedulerService.name))
  end

  let(:service) do
    context.instance(UpdaterService)
  end

  let(:lecture) do
    Lecture.new('Subject #', 107, %w[TM-1 TM-2], 'lector X')
  end

  it 'should success update time for lecture' do
    s_serv = context.inject(SchedulerService)

    new_day = 4
    new_num = 5

    info = { day_week: 1, num_lecture: 2, lecture: lecture }
    allow(s_serv).to receive(:delete_lecture).with(lecture).and_return(info)
    allow(s_serv).to receive(:add_lecture).with(new_day, new_num, lecture)

    service.update_time(lecture, new_day, new_num)

    expect(s_serv).to_not receive(:add_lecture).with(1, 2, lecture)
  end

  it 'should failed update time for lecture and rollback changes' do
    s_serv = context.inject(SchedulerService)

    new_day = 4
    new_num = 5

    info = { day_week: 1, num_lecture: 2, lecture: lecture }
    allow(s_serv).to receive(:delete_lecture).with(lecture).and_return(info)
    allow(s_serv).to receive(:add_lecture).with(new_day, new_num, lecture)
                                          .and_raise(RuntimeError)
    allow(s_serv).to receive(:add_lecture).with(1, 2, lecture)

    expect { service.update_time(lecture, new_day, new_num) }.to(
      raise_error BusinessException
    )
  end

  it 'should success update lecture model' do
    s_serv = context.inject(SchedulerService)

    info = { day_week: 1, num_lecture: 2, instance: lecture }
    allow(s_serv).to receive(:delete_lecture).with(lecture).and_return(info)
    allow(s_serv).to receive(:add_lecture).with(1, 2, any_args)

    expect(s_serv).to_not receive(:add_lecture).with(1, 2, lecture)

    service.update(lecture) do |changeable|
      changeable.cabinet = 709
    end
  end
end
