import { Controller } from "stimulus"
import { FetchRequest, patch } from '@rails/request.js'
import { dappStartProcess, dappFinishProcess } from 'helpers'
import { exchangeContract, tokenContract, web3, getAccount, etherAddress } from 'dapp'

export default class extends Controller {
	static targets = [ "sellAmount", "sellPrice"]
  connect() {}

	async submit(event){
		event.preventDefault();
		
		const account = await getAccount();
    const tokenGet = etherAddress;
		const sellAmount = this.sellAmountTarget.value;
		const sellPrice = this.sellPriceTarget.value;
    const amountGet = web3.utils.toWei((parseInt(sellAmount) * parseFloat(sellPrice)).toString(), 'ether');
    const tokenGive = tokenContract.options.address;
    const amountGive = web3.utils.toWei(sellAmount, 'ether');

		dappStartProcess('new-order');
    await exchangeContract.methods.makeOrder(tokenGet, amountGet, tokenGive, amountGive).send({ from: account })
    .on('transactionHash', (hash) => {
 			this.completeSellOrder(hash);
 			dappFinishProcess('new-order');
    })
    .on('error',(error) => {
      console.log(error);
      window.alert('There was an error!');
		  dappFinishProcess('new-order');
    })
	}
	
	async completeSellOrder(transactionHash){
	  const url = document.getElementById("sell-order-form").action
		const formData = new FormData();

		formData.append('transaction_hash', transactionHash);

    const request = new FetchRequest("post", url, {responseKind: "turbo-stream", body: formData})
    const response = await request.perform()

    if (response.ok) {
			console.log("Success");
    }
	}
}