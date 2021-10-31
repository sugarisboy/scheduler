# frozen_string_literal: true

require 'csv'

# Module for work with input and output streams.
module IOUtils
  DATA_DIR = '../../../data'

  def self.read_csv(file_name, sep)
    text = read_file(file_name)
    CSV.parse(text, col_sep: sep, headers: true)
  end

  def self.read_file(file_name)
    local_path = "#{DATA_DIR}/#{file_name}"
    path = File.expand_path(local_path, __dir__)
    File.read(path, encoding: 'utf-8')
  end

  def self.as_pink(str)
    colored(str, 35)
  end

  def self.as_green(str)
    colored(str, 32)
  end

  def self.as_aqua(str)
    colored(str, 36)
  end

  def self.as_gray(str)
    colored(str, 46)
  end

  def self.as_red(str)
    colored(str, 31)
  end

  def self.colored(str, code)
    format("\e[#{code}m#{str}\e[0m")
  end
end
