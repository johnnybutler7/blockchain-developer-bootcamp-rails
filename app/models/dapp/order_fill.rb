module Dapp
  class OrderFill
    def initialize(order_id:)
      @order_id = order_id
    end

    def run
      transaction = EXCHANGE.transact_and_wait.fill_order(order_id)
      trade = Blockchain::Logs.new(contract: EXCHANGE, event_name: 'Trade').call.detect{|e| e[:transactionHash] == transaction.id }
      Dapp::TradeDecorator.new(trade: trade).decorate
    end

    private
  
    attr_reader :order_id
  end
end