# frozen_string_literal: true

# Хранилище и фабрика бинов
class BeanFactory
  def initialize(context)
    @context = context
    @factory = {}
    @stack = []
  end

  # Добавить бин в контекст приложения
  def add(instance_bean)
    # TODO: add check is bean
    type = instance_bean.class

    if @factory.key?(type)
      raise ArgumentError, "Bean #{type} already defined in the context"
    end

    @factory[type] = instance_bean
  end

  # Поиск бина в контексте приложения
  # И попытка создать его в противном случае
  def find(type)
    if @factory.key?(type)
      @factory[type]
    else
      if @stack.include?(type)
        raise "Recursive creating bean #{type.name}: " \
              "#{@stack.join(' -> ')} -> #{type.name}"
      end

      @stack << type
      instance = create_new(type)
      @stack.delete(type)

      @factory[type] = instance
      instance
    end
  end

  # Создание нового бине
  def create_new(type)
    instance = Object.const_get(type.name).new
    instance.register_bean(@context)
    instance
  end

  # Принудительно сохранить в контекст приложения какой-либо бин
  def primary(type, value)
    @factory[type] = value
  end

  # Добавляет бин, если такого нет
  def add_bean_if_not_exist(type, value)
    return if @factory.key?(type)

    primary(type, value)
  end

  # Возвращает количество бинов в контексте
  def count
    @factory.length
  end
end
