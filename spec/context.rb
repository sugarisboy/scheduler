# frozen_string_literal: true

require_relative '../lib/api/context'
require_relative '../lib/app/config/env_config'

# Тестовый контекст
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
