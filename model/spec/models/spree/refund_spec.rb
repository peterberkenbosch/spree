require 'spec_helper'

describe Spree::Refund do
  let(:payment) { Spree::Payment.new(amount: 100, paid: true) }
  subject(:refund) { Spree::Refund.new(amount: 100, payments: [payment]) }

  describe '#cancel!' do
    before { refund.cancel! }

    it 'changes the state to canceled' do
      expect(refund.canceled?).to eq(true)
    end
  end

  describe '#approve!' do
    before { refund.approve! }

    it 'changes the state to approved' do
      expect(refund.approved?).to eq(true)
    end

    context 'when approved' do
      before { refund.approved = true }

      it 'raises an exception' do
        expect{ refund.approve! }.to raise_exception(Spree::IllegalOperation)
      end
    end

    context 'when canceled' do
      before { refund.canceled = true }

      it 'raises an exception' do
        expect{ refund.approve! }.to raise_exception(Spree::IllegalOperation)
      end
    end

    context 'when processed' do
      before { refund.processed = true }

      it 'raises an exception' do
        expect{ refund.approve! }.to raise_exception(Spree::IllegalOperation)
      end
    end
  end

  describe '#cancel!' do
    before { refund.cancel! }

    it 'changes the state to canceled' do
      expect(refund.canceled?).to eq(true)
    end

    context 'when processed' do
      before { refund.processed = true }

      it 'raises an exception' do
        expect{ refund.cancel! }.to raise_exception(Spree::IllegalOperation)
      end
    end

    context 'when canceled' do
      before { refund.canceled = true }

      it 'raises an exception' do
        expect{ refund.cancel! }.to raise_exception(Spree::IllegalOperation)
      end
    end
  end

  describe '#process!' do
    context 'when canceled' do
      before { refund.canceled = true }

      it 'raises an exception' do
        expect{ refund.process! }.to raise_exception(Spree::IllegalOperation)
      end
    end

    context 'when processed' do
      before { refund.processed = true }

      it 'raises an exception' do
        expect{ refund.process! }.to raise_exception(Spree::IllegalOperation)
      end
    end
  end

  context 'when approved' do
    before { refund.approved = true }

    describe 'process!' do
      before { refund.process! }

      it 'changes the state to processed' do
        expect(refund.processed?).to eq(true)
      end

      it 'refunds the entire payment' do
        expect(payment.refunded?).to eq(true)
      end
    end

    context 'and amount is less than payment' do
      it 'does stuff'
    end

    context 'and there are two payments' do
      it 'does stuff'
      # more scenarios needed here
    end

  end

  context 'when not approved' do
    before { refund.approved = false }

    it 'raises an exception' do
      expect{ refund.process! }.to raise_exception(Spree::IllegalOperation)
    end
  end

  describe '#amount=' do
    context 'when the amount is already set' do

      it 'raises an exception' do
        expect{ refund.amount = 50 }.to raise_exception(Spree::AttributeLocked)
      end
    end
  end

end