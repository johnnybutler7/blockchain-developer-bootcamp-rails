export const web3 = new Web3(Web3.givenProvider || window._blockchain_url);
const { abi } = require('./controllers/Exchange.json');
export const exchangeContract = new web3.eth.Contract(abi, '0xdC7b2845FEe467B64168a93382F30838B28F8DC2');

export async function getAccount() {
  const response = await web3.eth.getAccounts();
	const first_account = await response[0];
  return first_account;
}