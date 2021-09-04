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
        OpenStruct.new({success?: false, error: e, error_message: error_description(e)})
       end
    end

    private
  
    attr_reader :transaction
    
    def error_description(error)
      "There was a problem #{transaction.description} - #{error}"
    end
  end
end