# frozen_string_literal: true

require_relative '../../../lib/api/bean/bean'
require_relative '../validators/data_validator'
require_relative '../model/scheduler'
require_relative 'scheduler_repository'
require 'logger'

# deprecated
class LectorRepository

  def initialize
    @data = {}
  end

  def injections
    @scheduler_repository = inject(SchedulerRepository)
  end

  def save(lector)
    key = lector.fio
    if @data.key?(key)
      exist = @data[lector.fio]

      if !exist.equal?(lector)
        raise "Unique primary key '#{key}' lector already used, " \
              "can't save new #{lector}"
      end

      return exist
    end

    put_data(key, lector)
  end

  def find_by_fio(fio) end

  private

  def put_data(key, data)
    @data[key, data]
  end
end
