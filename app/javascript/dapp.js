export const web3 = new Web3(Web3.givenProvider || window._blockchain_url);
const exchangeAbi = require('./Exchange.json');
export const exchangeContract = new web3.eth.Contract(exchangeAbi.abi, '0xdb124f4D549C60849E385c0545a6158f9b6535AA');

const tokenAbi = require('./Token.json');
export const tokenContract = new web3.eth.Contract(tokenAbi.abi, '0xce7E7944196cAb4565f6fEA0001d1272b7092615');

export const etherAddress = '0000000000000000000000000000000000000000';

export async function getAccount() {
  const response = await web3.eth.getAccounts();
	const first_account = await response[0];
  return first_account;
}