# frozen_string_literal: true

require_relative '../lib/scheduler_app'

def main
  SchedulerApp.new
end

if (Gem.win_platform?)
  Encoding.default_external = Encoding.find(Encoding.locale_charmap)
  Encoding.default_internal = __ENCODING__

  [STDIN, STDOUT].each do |io|
    io.set_encoding(Encoding.default_external, Encoding.default_internal)
  end
end

main if __FILE__ == $PROGRAM_NAME
