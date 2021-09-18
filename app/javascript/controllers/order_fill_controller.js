import { Controller } from "stimulus"
import { FetchRequest, patch } from '@rails/request.js'
import { dappStartProcess, dappFinishProcess } from 'helpers'
import { exchangeContract, web3, getAccount } from 'dapp'

export default class extends Controller {
  connect() {}

	async click(event){
		const orderId = this.data.get('id');
    const account = await getAccount();

		dappStartProcess('order-book');
    await exchangeContract.methods.fillOrder(orderId).send({from: account})
	  .on('transactionHash', (hash) => {
 		  this.completeOrderFill(hash);
			dappFinishProcess('order-book');
	   })
	   .on('error', (error) => {
	     console.log(error);
	     window.alert('There was an error!');
			 dappFinishProcess('order-book');
	   })
	}
	
	async completeOrderFill(transactionHash){
	  const url = this.data.get('url');
		const table = document.getElementById('all-trades-list');
		const rows = table.rows;
		const first_row = rows[0];
		const prevTokenPrice = first_row.cells[2].innerHTML;
		const formData = new FormData();
		
		formData.append('prev_token_price', prevTokenPrice);
		formData.append('transaction_hash', transactionHash);
		
    const request = new FetchRequest("PUT", url, {responseKind: "turbo-stream", body: formData})
    const response = await request.perform()
    if (response.ok) {
			console.log("Success");
    }
	}
}
