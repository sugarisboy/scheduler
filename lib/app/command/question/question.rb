# frozen_string_literal: true

# Default description change it
class Question
  # @abstract
  def ask; end

  def input(welcome)
    raise 'Need block' unless block_given?

    loop do
      print welcome
      data = gets.chomp.force_encoding('utf-8').chomp.strip
      return yield data
    rescue ValidationException => e
      puts IOUtils.as_red(e)
    end
  end
end
