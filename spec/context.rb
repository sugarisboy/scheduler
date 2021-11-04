# frozen_string_literal: true

require_relative '../lib/api/context'

# Default description change it
class TestContext < Context
  def bean(type, value)
    @bean_factory.primary(type, value)
    envs = EnvConfig.new
    @bean_factory.primary(EnvConfig, envs)
    init_test_envs(envs)
    self
  end

  def instance(type)
    @bean_factory.create_new(type)
  end

  def init_test_envs(envs)
    envs.data_dir = '../../../spec/data'
  end
end
