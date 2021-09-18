import { Controller } from "stimulus"
import { FetchRequest, patch } from '@rails/request.js'
import { dappStartProcess, dappFinishProcess } from 'helpers'
import { exchangeContract, web3, getAccount } from 'dapp'

export default class extends Controller {
	static targets = [ "etherAmount"]
  connect() {}

	async submit(event){
		event.preventDefault();

		const depositWeiValue = web3.utils.toWei(this.etherAmountTarget.value, 'ether');
		const account = await getAccount();

		dappStartProcess('dapp-balance');
    await exchangeContract.methods.depositEther().send({from: account, value: depositWeiValue})
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