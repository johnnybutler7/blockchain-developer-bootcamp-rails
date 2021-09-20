import { Controller } from "stimulus"
import { FetchRequest, patch } from '@rails/request.js'
import { web3, exchangeContract, tokenContract,  getAccount} from 'dapp'

export default class extends Controller {
  async connect() {
		const account = await getAccount();
		console.log(account);
		this.setAccount(account);
  }

	async setAccount(account){
		const url = this.data.get('success-url');
		console.log(url);
    const request = new FetchRequest("GET", url, {responseKind: "JSON"})
		
		const response = await request.perform().then(response => response.json)
    .then(data => {
			if (data['account'] == account){
			  console.log('Account is the same, nothing to do here!');
			} else {
				this.reloadPage(url, account);
			}
    });
	}
	
	async reloadPage(url, account){
		const formData = new FormData();
	  formData.append('account', account);
    const request = new FetchRequest("PUT", url, {responseKind: "turbo-stream", body: formData});
		
    const response = await request.perform();
    if (response.ok) {
			console.log("Reoad the page!!");
			location.reload();
    }
	}
}
