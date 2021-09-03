module Dapp
  class SellOrder
    def initialize(params:)
      @params = params
    end

    def run
      transaction = EXCHANGE.transact_and_wait.make_order(token_get, amount_get, token_give, amount_give)
      order = Blockchain::Logs.new(contract: EXCHANGE, event_name: 'Order').find_by_transaction_id(transaction.id)
      Dapp::OrderDecorator.new(item: order).decorate
    end

    private
  
    attr_reader :params
    
    def token_get
      ENV['ETHER_ADDRESS']
    end
    
    def amount_get
      Ethereum::Formatter.new.to_wei(params[:sell_amount].to_i * params[:sell_price].to_f)
    end
    
    def token_give
      TOKEN.address
    end
    
    def amount_give
     Ethereum::Formatter.new.to_wei(params[:sell_amount].to_i)
    end
  end
end