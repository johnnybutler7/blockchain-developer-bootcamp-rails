module Dapp
  class OrderFill
    def initialize(transaction_hash:, prev_token_price:)
      @transaction_hash = transaction_hash
      @prev_token_price = prev_token_price
    end

    def run
      #transaction = EXCHANGE.transact_and_wait.fill_order(order_id)
      trade = Blockchain::Logs.new(contract: EXCHANGE, event_name: 'Trade').find_by_transaction_id(transaction_hash)
      Dapp::TradeDecorator.new(item: trade, prev_token_price: prev_token_price).decorate
    end
    
    def description
      "filling your order"
    end

    private
  
    attr_reader :transaction_hash, :prev_token_price
  end
end