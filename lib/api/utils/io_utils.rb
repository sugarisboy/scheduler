# frozen_string_literal: true

require 'csv'

# Модуль для работы с вводом и выводом данных
module IOUtils
  def self.read_csv(local_path, sep)
    text = read_file(local_path)
    CSV.parse(text, col_sep: sep, headers: true)
  end

  def self.read_file(local_path)
    path = File.expand_path(local_path, __dir__)
    File.read(path, encoding: 'utf-8')
  end

  def self.write_csv(local_path, sep, data)
    path = File.expand_path(local_path, __dir__)
    CSV.open(path, 'wb', col_sep: sep) do |csv|
      data.each { |row| csv << row }
    end
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
