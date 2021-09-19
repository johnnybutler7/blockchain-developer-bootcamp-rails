import { Controller } from "stimulus"
import { FetchRequest, patch } from '@rails/request.js'
import { dappStartProcess, dappFinishProcess } from 'helpers'
import { exchangeContract, tokenContract, web3, getAccount } from 'dapp'

export default class extends Controller {
	static targets = [ "tokenAmount"]
  connect() {}

	async submit(event){
		event.preventDefault();

		const depositWeiValue = web3.utils.toWei(this.tokenAmountTarget.value, 'ether');
		const account = await getAccount();
		
		console.log(exchangeContract.options.address);
		console.log(tokenContract.options.address);
		console.log(depositWeiValue);

		dappStartProcess('dapp-balance');
		await tokenContract.methods.approve(exchangeContract.options.address, depositWeiValue).send({ from: account })
		  .on('transactionHash', (hash) => {
		    exchangeContract.methods.depositToken(tokenContract.options.address, depositWeiValue).send({ from: account })
		    .on('transactionHash', (hash) => {
		 			this.completeTokenDeposit(hash);
		 			dappFinishProcess('dapp-balance');
		    })
		    .on('error',(error) => {
	  	    console.log(error);
	  	    window.alert('There was an error!');
	  			dappFinishProcess('dapp-balance');
		    })
		  })
		
		
    // await exchangeContract.methods.depositEther().send({from: account, value: depositWeiValue})
 // 	  .on('transactionHash', (hash) => {
 // 			this.completeEtherDeposit(hash);
 // 			dappFinishProcess('dapp-balance');
 // 	   })
 // 	   .on('error', (error) => {
 // 	     console.log(error);
 // 	     window.alert('There was an error!');
 // 			 dappFinishProcess('dapp-balance');
 // 	   })
	}
	
	async completeTokenDeposit(transactionHash){
	  const url = document.getElementById("token-deposit-form").action
    const request = new FetchRequest("post", url, {responseKind: "turbo-stream", body: {}})
    const response = await request.perform()

    if (response.ok) {
			console.log("Success");
    }
	}
}