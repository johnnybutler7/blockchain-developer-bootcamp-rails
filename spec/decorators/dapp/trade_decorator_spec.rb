require 'rails_helper'
RSpec.describe Dapp::TradeDecorator, type: :decorator do
  
  context 'buy transaction' do
    before(:all) do
      transaction = buy_transaction
      @trade_decorator = Dapp::TradeDecorator.new(item: transaction).decorate
    end
    
    it '.order_id' do
      expect(@trade_decorator.order_id).to eql 2
    end
    
    it '.ether_amount' do
      expect(@trade_decorator.ether_amount).to eql 100000000000000000
    end
    
    it '.token_amount' do
      expect(@trade_decorator.token_amount).to eql "100.0"
    end
    
    it '.token_price' do
      expect(@trade_decorator.token_price).to eql 0.001
    end
    
    it '.formatted_timestamp' do
      expect(@trade_decorator.formatted_timestamp.to_s).to eql "2021-08-29 07:55:29 +0100"
    end
      
    it '.order_type' do
      expect(@trade_decorator.order_type).to eql "buy"
    end
    
    it '.order_sign' do
      expect(@trade_decorator.order_sign).to eql "+"
    end
    
    it '.user' do
      expect(@trade_decorator.user).to eql "0xc04e86af403d9d7fcaaa9a1d0a829597e76e7cc1"
    end
    
    it '.user_fill' do
      expect(@trade_decorator.user_fill).to eql "0xfac023e806d7eecc933ee24890b96f04212da8ab"
    end
  end
  
  def buy_transaction
    {
      :logIndex=>"0x0",
      :transactionIndex=>"0x0", 
      :transactionHash=>"0x89be12b2674fd4e3aacf50447845bb328e69e6230e8dfa7ae2de3f0c1968d1dd", 
      :blockHash=>"0x7c47c07e05117e35b32f396f98969d12c020f7d7239d3d2aac1083ddf9f8d882", 
      :blockNumber=>"0xd", 
      :address=>"0x9f7355bf081520b0eebae5b661528958c696b73c", 
      :data=>"0x0000000000000000000000000000000000000000000000000000000000000002000000000000000000000000c04e86af403d9d7fcaaa9a1d0a829597e76e7cc10000000000000000000000007b901b233069d82be68de41b4dffa72373d3c9060000000000000000000000000000000000000000000000056bc75e2d631000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000016345785d8a0000000000000000000000000000fac023e806d7eecc933ee24890b96f04212da8ab00000000000000000000000000000000000000000000000000000000612b2f61", 
      :topics=>["0x0dddf4182dc0fc1a311cb75f049c97403c6b8a99cf6b2229a36e7c526acb3f81"], 
      :type=>"mined", 
      :args=>[2, "c04e86af403d9d7fcaaa9a1d0a829597e76e7cc1", "7b901b233069d82be68de41b4dffa72373d3c906", 100000000000000000000, "0000000000000000000000000000000000000000", 100000000000000000, "fac023e806d7eecc933ee24890b96f04212da8ab", 1630220129], 
      :contract=>"Exchange",
      :event=>"Trade"
    }
  end
  
  context 'sell transaction' do
    before(:all) do
      transaction = sell_transaction
      @trade_decorator = Dapp::TradeDecorator.new(item: transaction).decorate
    end
    
    it '.order_id' do
      expect(@trade_decorator.order_id).to eql 28
    end
    
    it '.ether_amount' do
      expect(@trade_decorator.ether_amount).to eql 656500000000000000
    end
    
    it '.token_amount' do
      expect(@trade_decorator.token_amount).to eql "101.0"
    end
    
    it '.token_price' do
      expect(@trade_decorator.token_price).to eql 0.0065
    end
    
    it '.formatted_timestamp' do
      expect(@trade_decorator.formatted_timestamp.to_s).to eql "2021-08-29 12:35:27 +0100"
    end
      
    it '.order_type' do
      expect(@trade_decorator.order_type).to eql "sell"
    end
    
    it '.order_sign' do
      expect(@trade_decorator.order_sign).to eql "-"
    end
    
    it '.user' do
      expect(@trade_decorator.user).to eql "0xc04e86af403d9d7fcaaa9a1d0a829597e76e7cc1"
    end
    
    it '.user_fill' do
      expect(@trade_decorator.user_fill).to eql "0xc04e86af403d9d7fcaaa9a1d0a829597e76e7cc1"
    end
  end
  
  def sell_transaction
    {
      :logIndex=>"0x0", 
      :transactionIndex=>"0x0", 
      :transactionHash=>"0x227a9430657e6d0fc7bbf435cd5d6757ad0cc46044c41da3d2bb547427a53605", 
      :blockHash=>"0x92f05bd75b9a82659c127abe3c61ff68a371d36f30d9db6429ded0461e387577", 
      :blockNumber=>"0x42", :address=>"0x9f7355bf081520b0eebae5b661528958c696b73c", 
      :data=>"0x000000000000000000000000000000000000000000000000000000000000001c000000000000000000000000c04e86af403d9d7fcaaa9a1d0a829597e76e7cc10000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000091c5b458f0b40000000000000000000000000007b901b233069d82be68de41b4dffa72373d3c90600000000000000000000000000000000000000000000000579a814e10a740000000000000000000000000000c04e86af403d9d7fcaaa9a1d0a829597e76e7cc100000000000000000000000000000000000000000000000000000000612b70ff", 
      :topics=>["0x0dddf4182dc0fc1a311cb75f049c97403c6b8a99cf6b2229a36e7c526acb3f81"], 
      :type=>"mined", 
      :args=>[28, "c04e86af403d9d7fcaaa9a1d0a829597e76e7cc1", "0000000000000000000000000000000000000000", 656500000000000000, "7b901b233069d82be68de41b4dffa72373d3c906", 101000000000000000000, "c04e86af403d9d7fcaaa9a1d0a829597e76e7cc1", 1630236927], 
      :contract=>"Exchange", 
      :event=>"Trade"
    }
  end
end
