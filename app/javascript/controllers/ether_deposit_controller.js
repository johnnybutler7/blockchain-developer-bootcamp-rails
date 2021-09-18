import { Controller } from "stimulus"
import { FetchRequest, patch } from '@rails/request.js'

export default class extends Controller {
	static targets = [ "etherAmount"]
  connect() {}

	async submit(event){
		event.preventDefault();
		
		const depositWeiValue = Web3.utils.toWei(this.etherAmountTarget.value, 'ether');

		const web3 = new Web3(Web3.givenProvider || window._blockchain_url);
		const { abi } = require('./Exchange.json');
		var smart_contract_interface = new web3.eth.Contract(abi, window._exchange_contract_address);

		const accounts = await web3.eth.getAccounts();
		const account = await accounts[0];
		
    await smart_contract_interface.methods.depositEther().send({from: account, value: depositWeiValue})
	  .on('transactionHash', (hash) => {
			console.log(hash);
 		  alert("success");
	   })
	   .on('error', (error) => {
	     console.log(error);
	     window.alert('There was an error!');
	   })
	}
}