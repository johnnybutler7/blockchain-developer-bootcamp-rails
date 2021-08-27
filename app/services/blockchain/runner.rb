module Blockchain
  class Runner
    def initialize(transaction:)
      @transaction = transaction
    end
  
    def run
     response = transaction.run
    rescue IOError => e
      OpenStruct.new({success?: false, error: e})
    else
      OpenStruct.new({success?: true, response: response})
    end

    private
  
    attr_reader :transaction
  end
end