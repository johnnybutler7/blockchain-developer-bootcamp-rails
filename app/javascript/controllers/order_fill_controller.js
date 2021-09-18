import { Controller } from "stimulus"
import { FetchRequest, patch } from '@rails/request.js'

export default class extends Controller {
  connect() {}

	async click(event){
		const web3 = new Web3(Web3.givenProvider || window._blockchain_url);
		const { abi } = require('./Exchange.json');
		var smart_contract_interface = new web3.eth.Contract(abi, window._exchange_contract_address);

		const accounts = await web3.eth.getAccounts();
		const account = await accounts[0];
		const orderId = this.data.get('id');
		
		document.getElementById('order-book').style.display ='none';
		document.getElementById('order-book-container').insertAdjacentHTML("beforebegin",'<div id="order-book-spinner" class="spinner-border text-light text-center"></div>')
    await smart_contract_interface.methods.fillOrder(orderId).send({from: account})
	  .on('transactionHash', (hash) => {
 		  this.order_fill(hash);
			this.reset_order_book();
	   })
	   .on('error', (error) => {
	     console.log(error);
	     window.alert('There was an error!');
			 this.reset_order_book();
	   })
	}
	
	reset_order_book() {
	 document.getElementById('order-book').style.display ='';
	 document.getElementById('order-book-spinner').remove();
	}
	
	async order_fill(transactionHash){
	  const url = this.data.get('url');
		var table = document.getElementById('all-trades-list');
		var rows = table.rows;
		var first_row = rows[0];
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
