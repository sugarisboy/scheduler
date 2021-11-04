# frozen_string_literal: true

require 'stringio'
require 'tty/prompt/test'
require_relative '../../context'
require_relative '../../../lib/app/config/env_config'
require_relative '../../../lib/app/command/command_save_to_file'

RSpec.describe CommandSaveToFile do
  let(:prompt) { TTY::Prompt::Test.new }
  let(:command) { context.instance(CommandSaveToFile) }
  let(:envs) { context.inject(EnvConfig) }

  let(:context) do
    TestContext.new
               .bean(TTY::Prompt, prompt)
  end

  it 'should save to file' do
    envs.file = 'temp.csv'
    command.execute
  end
end
