import { Controller } from "stimulus"
import { FetchRequest, patch } from '@rails/request.js'

export default class extends Controller {
  connect() {
  	const web3 = new Web3(Web3.givenProvider || "#<%= ENV['BLOCKCHAIN_URL'] %>");
  }
	
	async click(event){
		
		const web3 = new Web3(Web3.givenProvider || "#<%= ENV['BLOCKCHAIN_URL'] %>");
		const { abi } = require('./Exchange.json');
		var smart_contract_interface = new web3.eth.Contract(abi, '0xC44E2e0b9A384971a4B7862Dc89a64Cfb780efEc');
		var transactionHash = '';

		const accounts = await web3.eth.getAccounts();
		const account = await accounts[0];
		console.log(account);
		const orderId = this.data.get('id');
		
    await smart_contract_interface.methods.fillOrder(orderId).send({from: account})
	  .on('transactionHash', (hash) => {
 		  transactionHash = hash;
	   })
	   .on('error', (error) => {
	     console.log(error);
	     window.alert('There was an error!');
	   })
		
		console.log(transactionHash);
		
		
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
