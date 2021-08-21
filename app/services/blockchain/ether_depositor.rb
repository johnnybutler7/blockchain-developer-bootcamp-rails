module Blockchain
  class EtherDepositor
    def initialize(amount:)
      @amount = amount
      @function_name = 'depositEther'
    end
  
    def call
      transaction = build_transaction
      transaction.sign(key)
      BlOCKCHAIN_CLIENT.eth_send_raw_transaction(transaction.hex)
    rescue IOError => e
      OpenStruct.new({success?: false, error: e})
    else
      OpenStruct.new({success?: true})
    end

    private
  
    attr_reader :function_name, :amount
  
    def build_transaction
      Eth::Tx.new(tx_args)
    end
  
    def key
      Eth::Key.new priv: ENV['ACCOUNT_PRIVATE_KEY']
    end
  
    def tx_args
      {
        from: account,
        to: EXCHANGE.address,
        data: data,
        value: amount,
        nonce: BlOCKCHAIN_CLIENT.get_nonce(key.address),
        gas_limit: BlOCKCHAIN_CLIENT.gas_limit,
        gas_price: BlOCKCHAIN_CLIENT.gas_price
      }
    end
  
    def account
      BlOCKCHAIN_CLIENT.eth_accounts['result'][0]
    end
  
    def function
      EXCHANGE.parent.functions.find { |f| f.name == function_name }
    end

    def data
      encoder = Ethereum::Encoder.new
      inputs = abi['inputs'].map { |input| OpenStruct.new(input) }
      input = encoder.encode_arguments(inputs, [])
      encoder.ensure_prefix(function.signature + input)
    end
  
    def abi
      EXCHANGE.abi.find { |abi| abi['name'] == function_name }
    end
  end
end