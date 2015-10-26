require 'rspec'

RSpec.configure do |config|
  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  def desc(expression, opts = {})
    Cronex::ExpressionDescriptor.new(expression, opts).description
  end
end
