import { Controller } from "stimulus"
import { FetchRequest, patch } from '@rails/request.js'

export default class extends Controller {
  connect() {}
	
	async click(event){
	  const url = this.data.get('url');
		
    const request = new FetchRequest("PUT", url, {responseKind: "turbo-stream"})
    const response = await request.perform()
    if (response.ok) {
			console.log("Success");
    }
	}
}
