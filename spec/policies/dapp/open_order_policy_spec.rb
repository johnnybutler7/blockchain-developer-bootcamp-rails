require 'rails_helper'
RSpec.describe Dapp::OpenOrderPolicy, type: :policy do
  context 'open order' do
    before(:each) do
      allow(EXCHANGE.call).to receive(:order_filled).with(1).and_return(false)
      allow(EXCHANGE.call).to receive(:order_cancelled).with(1).and_return(false)
      @open_order_policy = Dapp::OpenOrderPolicy.new(order_id: 1)
    end
    
    it 'to be open' do
      expect(@open_order_policy.open?).to eql true
    end
  end
  
  context 'filled order' do
    before(:each) do
      allow(EXCHANGE.call).to receive(:order_filled).with(1).and_return(true)
      allow(EXCHANGE.call).to receive(:order_cancelled).with(1).and_return(false)
      @open_order_policy = Dapp::OpenOrderPolicy.new(order_id: 1)
    end
    
    it 'not to be open' do
      expect(@open_order_policy.open?).to eql false
    end
  end
  
  context 'cancelled order' do
    before(:each) do
      allow(EXCHANGE.call).to receive(:order_filled).with(1).and_return(false)
      allow(EXCHANGE.call).to receive(:order_cancelled).with(1).and_return(true)
       @open_order_policy = Dapp::OpenOrderPolicy.new(order_id: 1)
    end
    
    it 'not to be open' do
      expect(@open_order_policy.open?).to eql false
    end
  end
end