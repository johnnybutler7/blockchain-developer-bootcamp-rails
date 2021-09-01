module Dapp
  class TradesDecorator
    def initialize(items:, decorator:)
      @items = items
      @decorator = decorator
    end

    def call
      decorated_items = []
      prev_token_price = nil
      items.each do |item|
        decorate_item = decorator.new(item: item, prev_token_price: prev_token_price).decorate
        decorated_items << decorate_item
        prev_token_price = decorate_item.token_price
      end
      decorated_items.reverse
    end

    private

    attr_reader :items, :decorator
  end
end