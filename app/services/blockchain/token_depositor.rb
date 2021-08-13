module Blockchain
  class TokenDepositor
    def initialize(amount:)
      @amount = amount
      @function_name = 'depositToken'
    end
  
    def call
      TOKEN.transact_and_wait.approve(EXCHANGE.address, amount)
      EXCHANGE.transact_and_wait.deposit_token(TOKEN.address, amount)
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
      input = encoder.encode_arguments(inputs, [TOKEN.address, amount])
      encoder.ensure_prefix(function.signature + input)
    end
  
    def abi
      EXCHANGE.abi.find { |abi| abi['name'] == function_name }
    end
  end
end