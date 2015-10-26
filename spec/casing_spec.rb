require 'cronex'

module Cronex
  describe ExpressionDescriptor do

    subject(:expression) { '* * * * *' }

    context 'casing:' do
      it 'sentence' do
        expect(desc(expression, casing: :sentence)).to eq('Every minute')
      end

      it 'title' do
        expect(desc(expression, casing: :title)).to eq('Every Minute')
      end

      it 'lower' do
        expect(desc(expression, casing: :lower)).to eq('every minute')
      end
    end
  end
end
