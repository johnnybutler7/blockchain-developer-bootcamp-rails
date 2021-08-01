module Blockchain
  class Logs

    def self.get_logs(contract, event_name)
      raise ArgumentError, "invalid contract instance (#{contract.class.name})" unless contract.parent.is_a?(Ethereum::Contract)
      event_abi = contract.abi.find { |abi| abi['name'] == event_name.to_s }
      event_inputs = event_abi['inputs'].map { |input| OpenStruct.new(input) }
      sig = contract.parent.events.find { |e| e.name.to_s == event_name.to_s }.signature
      topics = [ENCODER.ensure_prefix(sig)]
      res = contract.parent.client.eth_get_logs(topics: topics, address: contract.address, fromBlock: '0x0', toBlock: 'latest')
      logs = res['result']
      logs.map do |log|
        decoded = {
          args: DECODER.decode_arguments(event_inputs, log['data']),
          contract: contract.parent.name,
          event: event_name
        }
        log.merge(decoded).deep_symbolize_keys
      end
    end

  end
end