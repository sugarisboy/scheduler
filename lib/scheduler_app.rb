# frozen_string_literal: true

require_relative 'api/application'
require_relative 'app/converter/model_file_converter'

# Главный класс приложения
class SchedulerApp < Application
  def injections
    @reader = inject(ModelFileConverter)
  end

  def load
    @reader.read
  end
end
