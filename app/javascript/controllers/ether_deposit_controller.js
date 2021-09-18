import { Controller } from "stimulus"
import { FetchRequest, patch } from '@rails/request.js'
import { dappStartProcess, dappFinishProcess } from 'helpers'

export default class extends Controller {
	static targets = [ "etherAmount"]
  connect() {}

	async submit(event){
		event.preventDefault();
		
		const depositWeiValue = Web3.utils.toWei(this.etherAmountTarget.value, 'ether');
		const web3 = new Web3(Web3.givenProvider || window._blockchain_url);
		const { abi } = require('./Exchange.json');
		const accounts = await web3.eth.getAccounts();
		const account = await accounts[0];
		const smart_contract_interface = new web3.eth.Contract(abi, window._exchange_contract_address);

		dappStartProcess('dapp-balance');
    await smart_contract_interface.methods.depositEther().send({from: account, value: depositWeiValue})
 	  .on('transactionHash', (hash) => {
 			this.completeEtherDeposit(hash);
 			dappFinishProcess('dapp-balance');
 	   })
 	   .on('error', (error) => {
 	     console.log(error);
 	     window.alert('There was an error!');
 			 dappFinishProcess('dapp-balance');
 	   })
	}
	
	async completeEtherDeposit(transactionHash){
	  const url = document.getElementById("ether-deposit-form").action
    const request = new FetchRequest("post", url, {responseKind: "turbo-stream", body: {}})
    const response = await request.perform()

    if (response.ok) {
			console.log("Success");
    }
	}
}