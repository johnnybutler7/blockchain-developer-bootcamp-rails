require 'rails_helper'
RSpec.describe Dapp::OpenOrdersQuery, type: :query do
  context 'all open orders' do
    before(:each) do
      allow_any_instance_of(Dapp::OpenOrderPolicy).to receive(:open?).and_return(true)
      @queried_orders = Dapp::OpenOrdersQuery.new(orders: orders).execute
    end
    
    it '.orders' do
      expect(@queried_orders.size).to eql 1
    end
  end
  
  context 'non open order' do
    before(:each) do
      allow_any_instance_of(Dapp::OpenOrderPolicy).to receive(:open?).and_return(false)
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