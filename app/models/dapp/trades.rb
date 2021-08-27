module Dapp
  class Trades
    def initialize(trades:)
      @trades = trades
    end

    def decorate
      decorated_trades = []
      trades.each do |trade|
        decorated_trades << Dapp::TradeDecorator.new(trade: trade).decorate
      end
      decorated_trades
    end

    private

    attr_reader :trades
  end
end