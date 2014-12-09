require 'spec_helper'

describe Spree::Payment do
  let(:payment) { Spree::Payment.new }

  describe '#cancel!' do

    before { payment.cancel! }

    it 'changes the state to canceled' do
      expect(payment.canceled?).to eq(true)
    end
  end

end