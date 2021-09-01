import { Controller } from "stimulus"
import { FetchRequest, patch } from '@rails/request.js'

export default class extends Controller {
  connect() {}
	
	async click(event){
	  const url = this.data.get('url');
		var table = document.getElementById('all-trades-list');
		var rows = table.rows;
		var first_row = rows[0];
		const prevTokenPrice = first_row.cells[2].innerHTML;
		const formData = new FormData();
		formData.append('prev_token_price', prevTokenPrice);
		
    const request = new FetchRequest("PUT", url, {responseKind: "turbo-stream", body: formData})
    const response = await request.perform()
    if (response.ok) {
			console.log("Success");
    }
	}
}
