PRECISION = 100000
BLOCKCHAIN_URL = "https://ropsten.infura.io/v3/#{ENV['INFURA_API_KEY']}"
BlOCKCHAIN_CLIENT = Ethereum::HttpClient.new(BLOCKCHAIN_URL)
TRUFFLE_PATH = Dir.pwd
EXCHANGE = Ethereum::Contract.create(name: "Exchange", truffle: { paths: [ TRUFFLE_PATH ] }, client: BlOCKCHAIN_CLIENT)
TOKEN = Ethereum::Contract.create(name: "Token", truffle: { paths: [ TRUFFLE_PATH ] }, client: BlOCKCHAIN_CLIENT)
ENCODER = Ethereum::Encoder.new
DECODER = Ethereum::Decoder.new