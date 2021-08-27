module Blockchain
  class Events
    def initialize(events:)
      @events = events
    end
    
    def open_orders
      account = BlOCKCHAIN_CLIENT.eth_accounts['result'][0]
      open_order_events = []
      events.each do |event|
        args = event[:args]
        order_id = args[0]
        order = EXCHANGE.call.orders(order_id)
        user = Ethereum::Formatter.new.to_address(args[1])
        tokenGive = args[4]
        if !EXCHANGE.call.order_filled(order_id) && !EXCHANGE.call.order_cancelled(order_id)
          orderType = order[4] == ENV['ETHER_ADDRESS'] ? 'buy' : 'sell'
          etherAmount, tokenAmount = extract_ether_token_amount(args)
          tokenPrice = calculate_token_price(etherAmount, tokenAmount)
          open_order_events << {orderId: order_id, etherAmount: Ethereum::Formatter.new.from_wei(etherAmount), tokenAmount: Ethereum::Formatter.new.from_wei(tokenAmount), tokenPrice: tokenPrice, orderType: orderType, user: user}
        end
      end
      open_order_events.reverse
    end

    private

    attr_reader :events
    
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