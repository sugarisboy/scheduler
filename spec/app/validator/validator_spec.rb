# frozen_string_literal: true

require_relative '../../../lib/app/validators/validator'

RSpec.describe Validator do
  let(:validator) { Validator.new }

  [
    [5, true],
    [1, true],
    [-5, false],
    [10, false]
  ].each do |value, success|
    it 'Should validate between 1 and 6' do
      if success
        expect { validator.between?(1, value, 6, 'field') }.to_not raise_error
      end

      unless success
        expect { validator.between?(1, value, 6, 'field') }.to raise_error
      end
    end
  end

  [
    ['asd', false],
    [1, true],
    [-5, true],
    [0, false],
    ['1', true],
    ['0', false]
  ].each do |value, success|
    it 'Should validate not zero' do
      if success
        expect { validator.not_zero?(value, 'field') }.to_not raise_error
      end

      unless success
        expect { validator.not_zero?(value, 'field') }.to raise_error
      end
    end
  end

  [
    ['', false],
    ['   ', false],
    ["\n", false],
    ['aaaaa', true],
    ['  a dsa asd  ', true]
  ].each do |value, success|
    it 'Should validate not empty' do
      if success
        expect { validator.not_empty?(value, 'field') }.to_not raise_error
      end

      unless success
        expect { validator.not_empty?(value, 'field') }.to raise_error
      end
    end
  end

  [
    ['5', true],
    ['9321', true],
    ['0', false],
    ['-7', false],
    ['-9999', false]
  ].each do |value, success|
    it 'Should validate not empty' do
      if success
        expect { validator.positive?(value, 'field') }.to_not raise_error
      end

      unless success
        expect { validator.positive?(value, 'field') }.to raise_error
      end
    end
  end
end
