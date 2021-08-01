module Blockchain
  class Logs
    def initialize(contract:, event_name:)
      @contract = contract
      @event_name = event_name
    end

    def call
      raise ArgumentError, "invalid contract instance (#{contract.class.name})" unless contract.parent.is_a?(Ethereum::Contract)
      results.map do |result|
        decoded = {
          args: DECODER.decode_arguments(event_inputs, result['data']),
          contract: contract.parent.name,
          event: event_name
        }
        result.merge(decoded).deep_symbolize_keys
      end
    end
    
    private
    
    attr_reader :contract, :event_name
    
    def event_abi
      contract.abi.find { |abi| abi['name'] == event_name.to_s }
    end
    
    def event_inputs
      event_abi['inputs'].map { |input| OpenStruct.new(input) }
    end
    
    def sig
      contract.parent.events.find { |e| e.name.to_s == event_name.to_s }.signature
    end
    
    def topics
      [ENCODER.ensure_prefix(sig)]
    end
    
    def results
      contract.parent.client.eth_get_logs(topics: topics, address: contract.address, fromBlock: '0x0', toBlock: 'latest')['result']
    end
  end
end