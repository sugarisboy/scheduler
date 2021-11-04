# frozen_string_literal: true

require_relative '../../api/bean/bean'

# Default description change it
class EnvConfig
  include Bean

  attr_accessor :data_dir, :file

  def initialize
    @data_dir = '../../../data'
    @file = 'data.csv'
  end
end
