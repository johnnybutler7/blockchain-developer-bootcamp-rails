require 'rails_helper'
RSpec.describe Dapp::OpenOrdersQuery, type: :query do
  context 'all open orders' do
    before(:each) do
      allow(EXCHANGE.call).to receive(:order_filled).with(1).and_return(false)
      allow(EXCHANGE.call).to receive(:order_cancelled).with(1).and_return(false)
      @queried_orders = Dapp::OpenOrdersQuery.new(orders: orders).execute
    end
    
    it '.orders' do
      expect(@queried_orders.size).to eql 1
    end
  end
  
  context 'filled orders' do
    before(:each) do
      allow(EXCHANGE.call).to receive(:order_filled).with(1).and_return(true)
      allow(EXCHANGE.call).to receive(:order_cancelled).with(1).and_return(false)
      @queried_orders = Dapp::OpenOrdersQuery.new(orders: orders).execute
    end
    
    it '.orders' do
      expect(@queried_orders.size).to eql 0
    end
  end
  
  context 'cancelled orders' do
    before(:each) do
      allow(EXCHANGE.call).to receive(:order_filled).with(1).and_return(false)
      allow(EXCHANGE.call).to receive(:order_cancelled).with(1).and_return(true)
      @queried_orders = Dapp::OpenOrdersQuery.new(orders: orders).execute
    end
    
    it '.orders' do
      expect(@queried_orders.size).to eql 0
    end
  end
  
  def orders
    order = {}
    order[:args] = [1]
    [order]
  end
end