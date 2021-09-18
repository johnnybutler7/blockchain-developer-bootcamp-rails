export function dappStartProcess(dappItem) {
	document.getElementById(dappItem).style.display ='none';
	document.getElementById(dappItem + '-container').insertAdjacentHTML("beforebegin",'<div id="' + dappItem + '-spinner" class="spinner-border text-light text-center"></div>')
}

export function dappFinishProcess(dappItem) {
 document.getElementById(dappItem).style.display = '';
 document.getElementById(dappItem + '-spinner').remove();
}
