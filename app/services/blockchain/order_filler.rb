module Blockchain
  class OrderFiller
    def initialize(order_id:)
      @order_id = order_id
    end

    def call
      transaction = EXCHANGE.transact_and_wait.fill_order(order_id)
    rescue IOError => e
      OpenStruct.new({success?: false, error: e})
    else
      event = Blockchain::Logs.new(contract: EXCHANGE, event_name: 'Trade').call.detect{|e| e[:transactionHash] == transaction.id }
      OpenStruct.new({success?: true, response: format_event(event)})
    end

    private
  
    attr_reader :order_id
    
    def format_event(event)
      account = BlOCKCHAIN_CLIENT.eth_accounts['result'][0]
      args = event[:args]
      order_id = args[0]
      order = EXCHANGE.call.orders(order_id)
      user = Ethereum::Formatter.new.to_address(args[1])
      userFill = Ethereum::Formatter.new.to_address(args[6])
      tokenGive = args[4]
      etherAmount, tokenAmount = extract_ether_token_amount(args)
      tokenPrice = calculate_token_price(etherAmount, tokenAmount)
      formattedTimestamp = Time.at(args[7])
      
      myOrder = user == account
      if myOrder
        orderType = order[4] == ENV['ETHER_ADDRESS'] ? 'buy' : 'sell'
      else
        orderType = order[4] == ENV['ETHER_ADDRESS'] ? 'sell' : 'buy'
      end
      orderSign = orderType == 'buy' ? '+' : '-'
      
      
      {orderId: order_id, etherAmount: etherAmount, tokenAmount: Ethereum::Formatter.new.from_wei(tokenAmount), tokenPrice: tokenPrice, formattedTimestamp: formattedTimestamp, orderType: orderType, orderSign: orderSign, user: user, userFill: userFill}
    end
    
    def extract_ether_token_amount(args)
      if args[4] == ENV['ETHER_ADDRESS']
        etherAmount = args[5]
        tokenAmount = args[3]
      else
        etherAmount = args[3]
        tokenAmount = args[5]
      end
      [etherAmount, tokenAmount]
    end
    
    def calculate_token_price(etherAmount, tokenAmount)
      tokenPrice = (etherAmount.to_f / tokenAmount.to_f)
      tokenPrice = (tokenPrice * PRECISION).round / PRECISION.to_f
    end
  end
end