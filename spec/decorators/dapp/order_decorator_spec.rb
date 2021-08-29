require 'rails_helper'
RSpec.describe Dapp::OrderDecorator, type: :decorator do
  
  context 'buy transaction' do
    before(:all) do
      transaction = buy_transaction
      @order_decorator = Dapp::OrderDecorator.new(item: transaction).decorate
    end

    it '.order_id' do
      expect(@order_decorator.order_id).to eql 26
    end
    
    it '.ether_amount' do
      expect(@order_decorator.ether_amount).to eql "0.033"
    end
    
    it '.token_amount' do
      expect(@order_decorator.token_amount).to eql "100.0"
    end
    
    it '.token_price' do
      expect(@order_decorator.token_price).to eql 0.00033
    end
    
    it '.order_type' do
      expect(@order_decorator.order_type).to eql "buy"
    end
    
    it '.user' do
      expect(@order_decorator.user).to eql "0xc04e86af403d9d7fcaaa9a1d0a829597e76e7cc1"
    end
  end
  
  def buy_transaction
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
      :event=>"Order"}
  end
  
  context 'sell transaction' do
    before(:all) do
      transaction = sell_transaction
      @order_decorator = Dapp::OrderDecorator.new(item: transaction).decorate
    end

    it '.order_id' do
      expect(@order_decorator.order_id).to eql 36
    end
    
    it '.ether_amount' do
      expect(@order_decorator.ether_amount).to eql "50.5"
    end
    
    it '.token_amount' do
      expect(@order_decorator.token_amount).to eql "101.0"
    end
    
    it '.token_price' do
      expect(@order_decorator.token_price).to eql 0.5
    end
      
    it '.order_type' do
      expect(@order_decorator.order_type).to eql "sell"
    end

    it '.user' do
      expect(@order_decorator.user).to eql "0xc04e86af403d9d7fcaaa9a1d0a829597e76e7cc1"
    end
  end
  
  def sell_transaction
    {
      :logIndex=>"0x0", 
      :transactionIndex=>"0x0", 
      :transactionHash=>"0x63156e87b3d3efd680e8caa431469ca00df95232c1c263ff221cbf20f4fa0cd7", 
      :blockHash=>"0xd17d1c1eb040b2ec53e4b7c496c7f11d544685ff49121b591c9c52200672bce1", 
      :blockNumber=>"0x52", 
      :address=>"0x9f7355bf081520b0eebae5b661528958c696b73c", 
      :data=>"0x0000000000000000000000000000000000000000000000000000000000000024000000000000000000000000c04e86af403d9d7fcaaa9a1d0a829597e76e7cc10000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000002bcd40a70853a00000000000000000000000000007b901b233069d82be68de41b4dffa72373d3c90600000000000000000000000000000000000000000000000579a814e10a74000000000000000000000000000000000000000000000000000000000000612b7523", 
      :topics=>["0x9d33853d43e3607b4cc01fdc78338ff2dca6fef7db9232dae6d3eb55fbc3b109"], 
      :type=>"mined", 
      :args=>[36, "c04e86af403d9d7fcaaa9a1d0a829597e76e7cc1", "0000000000000000000000000000000000000000", 50500000000000000000, "7b901b233069d82be68de41b4dffa72373d3c906", 101000000000000000000, 1630237987], 
      :contract=>"Exchange", 
      :event=>"Order"
    }
  end
end
