# frozen_string_literal: true


# TODO: FIX THIS

=begin
RSpec.describe SchedulerApp do
  let(:context) do
    TestContext.new
  end

  before do
    prompt.on :keypress do |e|
      prompt.trigger :keyup if e.value == 'u'
      prompt.trigger :keydown if e.value == 'd'
    end
  end

  it 'Should startup application' do
    # 8 Раз вниз и выход из приложения
    prompt.input << "dddd\nddddddddd\n"
    prompt.input.rewind
    app = SchedulerApp.new(context)
    expect(app).to_not be_nil
  end
end
=end
