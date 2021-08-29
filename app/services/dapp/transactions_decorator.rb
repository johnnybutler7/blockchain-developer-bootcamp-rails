module Dapp
  class TransactionsDecorator
    def initialize(items:, decorator:)
      @items = items
      @decorator = decorator
    end

    def call
      decorated_items = []
      items.each do |item|
        decorated_items << decorator.new(item: item).decorate
      end
      decorated_items
    end

    private

    attr_reader :items, :decorator
  end
end