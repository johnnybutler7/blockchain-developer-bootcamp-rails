class DepositsController < ApplicationController
  def create    
    etherAmount = Ethereum::Formatter.new.to_wei(params[:ether_amount].to_i)
    account = BlOCKCHAIN_CLIENT.eth_accounts['result'][0]
    
    key = Eth::Key.new priv: ENV['ACCOUNT_PRIVATE_KEY']
    function_name = 'depositEther'
    function = EXCHANGE.parent.functions.find { |f| f.name == function_name }
    abi = EXCHANGE.abi.find { |abi| abi['name'] == function_name }
    encoder = Ethereum::Encoder.new
    inputs = abi['inputs'].map { |input| OpenStruct.new(input) }
    input = encoder.encode_arguments(inputs, [])
    data = encoder.ensure_prefix(function.signature + input)
    tx_args = {
      from: account,
      to: EXCHANGE.address,
      data: data,
      value: etherAmount,
      nonce: BlOCKCHAIN_CLIENT.get_nonce(key.address),
      gas_limit: BlOCKCHAIN_CLIENT.gas_limit,
      gas_price: BlOCKCHAIN_CLIENT.gas_price
    }
    tx = Eth::Tx.new(tx_args)
    tx.sign(key)
    BlOCKCHAIN_CLIENT.eth_send_raw_transaction(tx.hex)

    redirect_to accounts_path, notice: 'Successfully deposited Ether'
  end
end