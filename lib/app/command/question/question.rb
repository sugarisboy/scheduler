# frozen_string_literal: true

# Родительский класс для вопросов
# Состоит из осмысленного вопроса и валидации ответов
# в случае необходимостиЮ, служит помошником для комманд
class Question
  # @abstract
  # Метод вызова вопроса
  def ask; end

  # Вспомогательный метод, для задания и обработки запроса
  # Принимает в качестве аргумент welcome сообщение, а также
  # блок для обработки и валидации ответа пользователя
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
