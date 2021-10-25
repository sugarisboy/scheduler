# frozen_string_literal: true

require_relative '../../../lib/api/bean/bean'
require_relative '../validators/data_validator'
require 'logger'

# Default description change it
class SchedulerRepository
  include Bean

  def injections
    @scheduler = @context.inject(Scheduler)
    @validator = @context.inject(DataValidator)
  end

  def save_lecture(day_week, num_lecture, lecture)
    Log.debug("Start create lecture #{day_week},#{num_lecture},#{lecture}")

    @validator.validate_day_week(day_week)
    @validator.validate_num_lecture(num_lecture)

    day = @scheduler.data[day_week]
    num = day.data[num_lecture]
    num << lecture
    Log.debug("Finish creating lecture #{day_week},#{num_lecture},#{lecture}")
  end
end
