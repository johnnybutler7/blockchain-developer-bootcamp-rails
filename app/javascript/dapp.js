export const web3 = new Web3(Web3.givenProvider || window._blockchain_url);
const exchangeAbi = require('./Exchange.json');
export const exchangeContract = new web3.eth.Contract(exchangeAbi.abi, '0x4A8139C0eA4714b3d9050151cF82Ef7371228522');

const tokenAbi = require('./Token.json');
export const tokenContract = new web3.eth.Contract(tokenAbi.abi, '0x6b6C056f9D63A68D9Eaafb2AD65Ee3896615B53D');

export async function getAccount() {
  const response = await web3.eth.getAccounts();
	const first_account = await response[0];
  return first_account;
}