module Blockchain
  class Events
    
    def initialize(events:)
      @events = events
    end
    
    def trades
      trade_events = []
      events.each do |event|
        args = event[:args]
        tokenGive = args[4]
        if tokenGive == ENV['ETHER_ADDRESS']
          etherAmount = args[5]
          tokenAmount = args[3]
        else
          etherAmount = args[3]
          tokenAmount = args[5]
        end
      
        tokenPrice = (etherAmount.to_f / tokenAmount.to_f)
        tokenPrice = (tokenPrice * PRECISION).round / PRECISION.to_f
        formattedTimestamp = Time.at(args[7])
      
        trade_events << {etherAmount: etherAmount, tokenAmount: Ethereum::Formatter.new.from_wei(tokenAmount), tokenPrice: tokenPrice, formattedTimestamp: formattedTimestamp}
      end
      trade_events
    end
    
    private
    
    attr_reader :events
  end
end