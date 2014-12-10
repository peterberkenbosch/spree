require 'spec_helper'

describe Spree::Payment do
  let(:payment) { Spree::Payment.new }

  describe '#cancel!' do

    before { payment.cancel! }

    it 'changes the state to canceled' do
      expect(payment.canceled?).to eq(true)
    end
  end

  describe '#amount=' do
    context 'when the amount is already set' do
      let(:payment) { Spree::Payment.new(amount: 50) }

      it 'raises an exception' do
        expect{ payment.amount = 50 }.to raise_exception(Spree::AttributeLocked)
      end
    end
  end

end