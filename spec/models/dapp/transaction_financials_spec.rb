require 'rails_helper'
RSpec.describe Dapp::TransactionFinancials, type: :model do
  context 'buy transactions' do
    before(:all) do
      @fiananicals = Dapp::TransactionFinancials.new(token_give: 'myaddres', 
                                                     amount_get: 100, 
                                                     amount_give: 200)
    end
    
    it '.ether_amount' do
      expect(@fiananicals.ether_amount).to eql 100
    end
    
    it '.token_amount' do
      expect(@fiananicals.token_amount).to eql 200
    end
    
    it '.token_price' do
      expect(@fiananicals.token_price).to eql 0.5
    end
  end
  
  context 'sell transactions' do
    before(:all) do
      @fiananicals = Dapp::TransactionFinancials.new(token_give: '0000000000000000000000000000000000000000', 
                                                     amount_get: 100, 
                                                     amount_give: 200)
    end
    
    it '.ether_amount' do
      expect(@fiananicals.ether_amount).to eql 200
    end
    
    it '.token_amount' do
      expect(@fiananicals.token_amount).to eql 100
    end
    
    it '.token_price' do
      expect(@fiananicals.token_price).to eql 2.0
    end
  end
end