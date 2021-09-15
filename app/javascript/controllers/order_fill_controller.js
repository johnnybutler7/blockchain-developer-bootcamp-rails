import { Controller } from "stimulus"
import { FetchRequest, patch } from '@rails/request.js'

export default class extends Controller {
  connect() {
		// const web3 = new Web3(Web3.givenProvider || "ws://localhost:7545");
//
// 		const { abi } = require('./Exchange.json');
// 		var smart_contract_interface = new web3.eth.Contract(abi, '0xA65de02b61970Dc48E16864239618c3d7a5b0d74');
// 		console.log(smart_contract_interface);
  }
	
	async click(event){		
		
		const web3 = new Web3(Web3.givenProvider || "ws://localhost:7545");
		
		console.log(this.data);
		
		const { abi } = require('./Exchange.json');
		const orderId  = this.data.get('id');
		var smart_contract_interface = new web3.eth.Contract(abi, '0xFEB051e0D94C3aCC56769C7f123F9f4E7D653357');
		//const accounts = web3.
		//const account = accounts[0];
    const accounts = await web3.eth.getAccounts()
    const account = await accounts[0]
		
		//console.log(orderId)
		console.log(account)
		
		//const result = await smart_contract_interface.methods.fillOrder(orderId).send({from: account});
		
		//console.log(result);
		const transaction_hash = await smart_contract_interface.methods.fillOrder(orderId).send({from: account})
	  .on('transactionHash', (hash) => {
 		  hash
	   })
	   .on('error', (error) => {
	     console.log(error)
	     window.alert('There was an error!')
	   })
		 
		const trade = JSON.parse(web3.eth.getTransactionReceipt(transaction_hash))

	  const url = this.data.get('url');
		var table = document.getElementById('all-trades-list');
		var rows = table.rows;
		var first_row = rows[0];
		const prevTokenPrice = first_row.cells[2].innerHTML;
		const formData = new FormData();
		formData.append('prev_token_price', prevTokenPrice);
		formData.append('transaction_hash', transaction_hash);

    const request = new FetchRequest("PUT", url, {responseKind: "turbo-stream", body: formData})
    const response = await request.perform()
    if (response.ok) {
			console.log("Success");
    }
	}
}
