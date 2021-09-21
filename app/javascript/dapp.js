if(typeof window.ethereum =='undefined'){
	window.alert('Please install MetaMask')
  window.location.assign("https://metamask.io/")
}

export const web3 = new Web3(Web3.givenProvider || window._blockchain_url);
const exchangeAbi = require('./Exchange.json');
export const exchangeContract = new web3.eth.Contract(exchangeAbi.abi, '0x6fBB2975DFf916ec1968466d3a06F9187D7030F8');

console.log(exchangeAbi.abi);

const tokenAbi = require('./Token.json');
export const tokenContract = new web3.eth.Contract(tokenAbi.abi, '0x1395740E01af667b9E2743c9af57749c87Ee9214');

export const etherAddress = '0000000000000000000000000000000000000000';

export async function getAccount() {
  const response = await web3.eth.getAccounts();
	const first_account = await response[0];
  return first_account;
}
