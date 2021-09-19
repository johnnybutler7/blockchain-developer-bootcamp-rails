import { Controller } from "stimulus"
import { FetchRequest, patch } from '@rails/request.js'
import { dappStartProcess, dappFinishProcess } from 'helpers'
import { exchangeContract, web3, getAccount } from 'dapp'

export default class extends Controller {
  connect() {}

	async click(event){
		const orderId = this.data.get('id');
    const account = await getAccount();

		dappStartProcess('my-orders');
    await exchangeContract.methods.cancelOrder(orderId).send({from: account})
 	  .on('transactionHash', (hash) => {
 		  this.completeOrderCancel(hash);
 			dappFinishProcess('my-orders');
 	   })
 	   .on('error', (error) => {
 	     console.log(error);
 	     window.alert('There was an error!');
 			 dappFinishProcess('my-orders');
 	   })
	}
	
	async completeOrderCancel(transactionHash){
	  const url = this.data.get('url');

    const request = new FetchRequest("DELETE", url, {responseKind: "turbo-stream", body: {}})
    const response = await request.perform()
    if (response.ok) {
			console.log("Success");
    }
	}
}
