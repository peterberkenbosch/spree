require 'spec_helper'

describe Spree::Customer do
  let(:customer) { Spree::Customer.new }

  describe '#add_credit' do
    let(:credit) { Spree::Credit.new }
    before { customer.add_credit (credit) }

    it 'adds the credit to the collection' do
      expect(customer.credits).to include(credit)
    end
  end

end