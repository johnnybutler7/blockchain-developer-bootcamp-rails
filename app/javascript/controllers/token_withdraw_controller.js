import { Controller } from "stimulus"
import { FetchRequest, patch } from '@rails/request.js'
import { dappStartProcess, dappFinishProcess } from 'helpers'
import { exchangeContract, tokenContract, web3, getAccount } from 'dapp'

export default class extends Controller {
	static targets = [ "tokenAmount"]
  connect() {}

	async submit(event){
		event.preventDefault();

		const withdrawWeiValue = web3.utils.toWei(this.tokenAmountTarget.value, 'ether');
		const account = await getAccount();
		
		dappStartProcess('dapp-balance');
    await exchangeContract.methods.withdrawToken(tokenContract.options.address,withdrawWeiValue).send({ from: account })
    .on('transactionHash', (hash) => {
 			this.completeTokenWithdraw(hash);
 			dappFinishProcess('dapp-balance');
    })
    .on('error',(error) => {
	    console.log(error);
	    window.alert('There was an error!');
			dappFinishProcess('dapp-balance');
    })
	
	}
	
	async completeTokenWithdraw(transactionHash){
	  const url = document.getElementById("token-withdraw-form").action
    const request = new FetchRequest("post", url, {responseKind: "turbo-stream", body: {}})
    const response = await request.perform()

    if (response.ok) {
			console.log("Success");
    }
	}
}