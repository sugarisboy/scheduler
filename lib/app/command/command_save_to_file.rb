# frozen_string_literal: true

require_relative 'command'
require_relative 'question/question_week_day'
require_relative 'question/question_num_lecture'
require_relative 'question/question_select_lecture'
require_relative '../service/scheduler_service'
require_relative '../converter/model_file_converter'
require_relative '../../api/bean/bean'

# Команда для удаления элемента раписания
class CommandSaveToFile < Command
  include Bean

  def injections
    @model_file_converter = inject(ModelFileConverter)
    @service = inject(SchedulerService)
  end

  def initialize
    super
    @name = 'Сохранить в файл'
  end

  def execute
    scheduler = @service.find
    @model_file_converter.write(scheduler)
  end
end
