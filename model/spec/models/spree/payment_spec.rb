require 'spec_helper'

describe Spree::Payment do
  let(:payment) { Spree::Payment.new }

  describe '#cancel!' do
    context 'when unpaid' do
      subject(:payment) { Spree::Payment.new(:paid => false) }
      before { payment.cancel! }

      it 'changes the state to canceled' do
        expect(payment.canceled?).to eq(true)
      end
    end

    context 'when paid' do
      before { payment.paid = true }

      it 'raises an exception' do
        expect{ payment.cancel! }.to raise_exception(Spree::IllegalOperation)
      end
    end

    context 'when refunded' do
      before { payment.refunded = true }

      it 'raises an exception' do
        expect{ payment.cancel! }.to raise_exception(Spree::IllegalOperation)
      end
    end

    context 'when partially refunded' do
      before { payment.partially_refunded = true }

      it 'raises an exception' do
        expect{ payment.cancel! }.to raise_exception(Spree::IllegalOperation)
      end
    end

  end

  describe '#refund!' do
    context 'when paid' do
      before { payment.paid = true }

      it 'does stuff'
    end

    context 'when partially refunded' do
      before { payment.partially_refunded = true }

      it 'does stuff'
    end

    context 'when canceled' do
      before { payment.canceled = true}

      it 'raises an exception' do
        expect{ payment.refund! }.to raise_exception(Spree::IllegalOperation)
      end
    end

    context 'when refunded' do
      before { payment.refunded = true}

      it 'raises an exception' do
        expect{ payment.refund! }.to raise_exception(Spree::IllegalOperation)
      end
    end
  end

  describe '#pay!' do
    context 'when unpaid' do
      let(:payment_method) { Spree::PaymentMethod.new }
      subject(:payment) { Spree::Payment.new(paid: false, payment_method: payment_method) }
      before { payment.pay! }

      it 'sets the state to paid' do
        expect(payment.paid).to eq(true)
      end

      it 'payment method captures the payment'
    end

    context 'when paid' do
      before { payment.paid = true }

      it 'raises an exception' do
        expect{ payment.pay! }.to raise_exception(Spree::IllegalOperation)
      end
    end

    context 'when canceled' do
      before { payment.canceled = true}

      it 'raises an exception' do
        expect{ payment.pay! }.to raise_exception(Spree::IllegalOperation)
      end
    end

    context 'when refunded' do
      before { payment.refunded = true}

      it 'raises an exception' do
        expect{ payment.pay! }.to raise_exception(Spree::IllegalOperation)
      end
    end

    context 'when partially refunded' do
      before { payment.partially_refunded = true}

      it 'raises an exception' do
        expect{ payment.pay! }.to raise_exception(Spree::IllegalOperation)
      end
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