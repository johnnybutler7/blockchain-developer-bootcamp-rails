module Dapp
  class OrderFill
    def initialize(order_id:, prev_token_price:)
      @order_id = order_id
      @prev_token_price = prev_token_price
    end

    def run
      transaction = EXCHANGE.transact_and_wait.fill_order(order_id)
      trade = Blockchain::Logs.new(contract: EXCHANGE, event_name: 'Trade').find_by_transaction_id(transaction.id)
      Dapp::TradeDecorator.new(item: trade, prev_token_price: prev_token_price).decorate
    end

    private
  
    attr_reader :order_id, :prev_token_price
  end
end