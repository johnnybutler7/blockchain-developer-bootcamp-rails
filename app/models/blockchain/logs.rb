module Blockchain
  class Logs
    def initialize(contract:, event_name:)
      @contract = contract
      @event_name = event_name
    end

    def call
      raise ArgumentError, "invalid contract instance (#{contract.class.name})" unless contract.parent.is_a?(Ethereum::Contract)
      results.map do |result|
        decoded = decode_data(result['data'])
        result.merge(decoded).deep_symbolize_keys
      end
    end
    
    def find_by_transaction_id(trans_id)
      log_params = default_log_params.merge(transaction_hash: trans_id)
      result = contract.parent.client.eth_get_logs(log_params)['result'].first
      decoded = decode_data(result['data'])
      result.merge(decoded).deep_symbolize_keys
    end
    
    private
    
    attr_reader :contract, :event_name
    
    def results
      contract.parent.client.eth_get_logs(default_log_params)['result']
    end
    
    def decode_data(data)
      {
        args: DECODER.decode_arguments(event_inputs, data),
        contract: contract.parent.name,
        event: event_name
      }
    end
    
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
    
    def default_log_params
      {topics: topics, address: contract.address, fromBlock: '0x0', toBlock: 'latest'}
    end
  end
end