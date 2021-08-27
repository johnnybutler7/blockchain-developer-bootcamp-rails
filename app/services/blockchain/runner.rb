module Blockchain
  class Runner
    def initialize(transaction:)
      @transaction = transaction
    end
  
    def run
      begin
        response = transaction.run
        OpenStruct.new({success?: true, response: response})
      rescue IOError => e
        OpenStruct.new({success?: false, error: e})
       end
    end

    private
  
    attr_reader :transaction
  end
end