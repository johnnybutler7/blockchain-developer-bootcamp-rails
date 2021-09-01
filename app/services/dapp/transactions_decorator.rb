module Dapp
  class TransactionsDecorator
    def initialize(items:)
      @items = items
    end

    def call
      decorated_items = []
      items.each do |item|
        decorated_items << Dapp::OrderDecorator.new(item: item).decorate
      end
      decorated_items
    end

    private

    attr_reader :items
  end
end