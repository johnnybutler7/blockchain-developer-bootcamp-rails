module Dapp
  class SellOrder
    def initialize(transaction_hash:)
      @transaction_hash = transaction_hash
    end

    def run
      order = Blockchain::Logs.new(contract: EXCHANGE, event_name: 'Order').find_by_transaction_id(transaction_hash)
      Dapp::OrderDecorator.new(item: order).decorate
    end
    
    def description
      'placing your sell order'
    end

    private
  
    attr_reader :transaction_hash
  end
end