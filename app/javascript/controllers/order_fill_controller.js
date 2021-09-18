import { Controller } from "stimulus"
import { FetchRequest, patch } from '@rails/request.js'
import { dappStartProcess, dappFinishProcess } from 'helpers'

export default class extends Controller {
  connect() {}

	async click(event){
		const web3 = new Web3(Web3.givenProvider || window._blockchain_url);
		const { abi } = require('./Exchange.json');
		const accounts = await web3.eth.getAccounts();
		const account = await accounts[0];
		const orderId = this.data.get('id');
		const smart_contract_interface = new web3.eth.Contract(abi, window._exchange_contract_address);
		
		dappStartProcess('order-book');
    await smart_contract_interface.methods.fillOrder(orderId).send({from: account})
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
