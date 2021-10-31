# frozen_string_literal: true

require 'singleton'
require_relative 'bean/bean'
require_relative 'bean/bean_factory'

# Контекст всего приложения, при этом является
# бином и может быть внедрен в любом классе
class Context
  include Bean

  attr_reader :bean_factory

  def initialize
    @bean_factory = BeanFactory.new(self)
    register_bean(self)
  end

  def add_bean(instance_bean)
    @bean_factory.add(instance_bean)
  end

  def add_bean_if_not_exist(type, instance_bean)
    @bean_factory.add_bean_if_not_exist(type, instance_bean)
  end

  def inject(type)
    @bean_factory.find(type)
  end

  def injects(type)
    @bean_factory.find_all(type)
  end

  def to_s
    "Context[beanCount=#{@bean_factory.count}"
  end
end
