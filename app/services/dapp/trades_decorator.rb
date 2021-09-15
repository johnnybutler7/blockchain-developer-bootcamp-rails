module Dapp
  class TradesDecorator
    def initialize(items:)
      @items = items
    end

    def call
      decorated_items = []
      prev_token_price = nil
      items.each do |item|
        decorate_item = Dapp::TradeDecorator.new(item: item, prev_token_price: prev_token_price).decorate
        decorated_items << decorate_item
        prev_token_price = decorate_item.token_price
      end
    end

    private

    attr_reader :items
  end
end