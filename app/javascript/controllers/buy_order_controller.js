import { Controller } from "stimulus"
import { FetchRequest, patch } from '@rails/request.js'
import { dappStartProcess, dappFinishProcess } from 'helpers'
import { exchangeContract, tokenContract, web3, getAccount, etherAddress } from 'dapp'

export default class extends Controller {
	static targets = [ "buyAmount", "buyPrice"]
  connect() {}

	async submit(event){
		event.preventDefault();
		
		const account = await getAccount();
    const tokenGet = tokenContract.options.address
		const buyAmount = this.buyAmountTarget.value
		const buyPrice = this.buyPriceTarget.value
    const amountGet = web3.utils.toWei(buyAmount)
    const tokenGive = etherAddress;
    const amountGive = web3.utils.toWei((parseInt(buyAmount) * parseFloat(buyPrice)).toString())
		
		console.log(amountGive);

		dappStartProcess('new-order');
    await exchangeContract.methods.makeOrder(tokenGet, amountGet, tokenGive, amountGive).send({ from: account })
    .on('transactionHash', (hash) => {
 			this.completeBuyOrder(hash);
 			dappFinishProcess('new-order');
    })
    .on('error',(error) => {
      console.log(error);
      window.alert('There was an error!');
		  dappFinishProcess('new-order');
    })
	}
	
	async completeBuyOrder(transactionHash){
	  const url = document.getElementById("buy-order-form").action
		const formData = new FormData();

		formData.append('transaction_hash', transactionHash);

    const request = new FetchRequest("post", url, {responseKind: "turbo-stream", body: formData})
    const response = await request.perform()

    if (response.ok) {
			console.log("Success");
    }
	}
}