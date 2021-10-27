# frozen_string_literal: true

# Хранилище и фабрика бинов
class BeanFactory
  def initialize(context)
    @context = context
    @factory = {}
    @stack = []
  end

  def add(instance_bean)
    # TODO: add check is bean
    type = instance_bean.class

    if @factory.key?(type)
      raise ArgumentError, "Bean #{type} already defined in the context"
    end

    @factory[type] = instance_bean
  end

  def find(type)
    # TODO: add check is class
    # TODO: add check is bean instance of
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

  def create_new(type)
    instance = Object.const_get(type.name).new
    instance.register_bean(@context)
    instance
  end

  def primary(type, value)
    @factory[type] = value
  end

  def bean?(type)
    pp type
    true
  end
end
