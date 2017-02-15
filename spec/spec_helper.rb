require 'rspec'

RSpec.configure do |config|
  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  def desc(expression, opts = {})
    Cronex::ExpressionDescriptor.new(expression, opts).description
  end

  def desc_pt_br(expression, opts = {})
    Cronex::ExpressionDescriptor.new(expression, opts, 'pt_BR').description
  end

  def desc_fr(expression, opts = {})
    Cronex::ExpressionDescriptor.new(expression, opts, 'fr').description
  end
end
