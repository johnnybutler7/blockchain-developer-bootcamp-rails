require 'rails_helper'
RSpec.describe Dapp::TransactionsDecorator, type: :model do
  context 'Orders' do
    before(:all) do
      @decorated_orders = Dapp::TransactionsDecorator.new(items: orders).call
    end
    
    it 'returns a collection of orders' do
      expect(@decorated_orders).to be_a Array
    end
    
    it '.call' do
      first_order = @decorated_orders.first
      expect(first_order).to respond_to(:order_id)
    end
  end
  
  def orders
    [
      {
        :logIndex=>"0x0", 
        :transactionIndex=>"0x0", 
        :transactionHash=>"0x45082761c3f2996c4cd25cd4c01bd04bab9cb8c2131feab9a655451922896965", 
        :blockHash=>"0xde4a12ffdad101430c0d96367fcc0efe40503b22a927d93aa938f3fc52b50742", 
        :blockNumber=>"0x3f", :address=>"0x9f7355bf081520b0eebae5b661528958c696b73c", 
        :data=>"0x000000000000000000000000000000000000000000000000000000000000001a000000000000000000000000c04e86af403d9d7fcaaa9a1d0a829597e76e7cc10000000000000000000000007b901b233069d82be68de41b4dffa72373d3c9060000000000000000000000000000000000000000000000056bc75e2d63100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000753d533d96800000000000000000000000000000000000000000000000000000000000612b70d9", 
        :topics=>["0x9d33853d43e3607b4cc01fdc78338ff2dca6fef7db9232dae6d3eb55fbc3b109"], 
        :type=>"mined", 
        :args=>[26, "c04e86af403d9d7fcaaa9a1d0a829597e76e7cc1", "7b901b233069d82be68de41b4dffa72373d3c906", 100000000000000000000, "0000000000000000000000000000000000000000", 33000000000000000, 1630236889], 
        :contract=>"Exchange", 
        :event=>"Order"
      }
    ]
  end
end