PRECISION = 100000
BlOCKCHAIN_CLIENT = Ethereum::HttpClient.new(ENV['BLOCKHAIN_URL'])
TRUFFLE_PATH = Dir.pwd
EXCHANGE = Ethereum::Contract.create(name: "Exchange", truffle: { paths: [ TRUFFLE_PATH ] }, client: BlOCKCHAIN_CLIENT)
TOKEN = Ethereum::Contract.create(name: "Token", truffle: { paths: [ TRUFFLE_PATH ] }, client: BlOCKCHAIN_CLIENT)
ENCODER = Ethereum::Encoder.new
DECODER = Ethereum::Decoder.new