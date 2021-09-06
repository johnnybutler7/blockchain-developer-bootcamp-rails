require 'rails_helper'
RSpec.describe Dapp::Graph, type: :model do
  context 'with orders' do
    before(:all) do
      orders = [
        OpenStruct.new(token_amount: "100.0", token_price: 0.001, formatted_timestamp: '2021-09-06 16:14:49 +0100'.to_time), 
        OpenStruct.new(token_amount: "50.0", token_price: 0.0002, formatted_timestamp: '2021-09-06 16:14:51 +0100'.to_time), 
        OpenStruct.new(token_amount: "200.0", token_price: 0.00075, formatted_timestamp: '2021-09-06 16:14:52 +0100'.to_time)
      ]

      @graph = Dapp::Graph.new(orders: orders)
    end
    
    it '.last_price_change' do
      expect(@graph.last_price_change).to eql "+"
    end
    
    it '.last_price' do
      expect(@graph.last_price).to eql 0.00075
    end
    
    it '.series_data' do
      expect(@graph.series_data).to eql [[1630940400000, [0.001, 0.001, 0.0002, 0.00075]]]
    end
  end
end