// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

Fields = {
	observeCurrencyFields: function(){			
		$$('input.currency').each(function(elem){
			Fields.setupCurrencyObservers(elem)
		});
	},
	setupCurrencyObservers: function(elem){
		elem.value = Number(elem.value).toFixed(2);
		Event.observe(elem,'click',function(){
			this.select();
		});
		Event.observe(elem,'blur',function(){
			this.value = Number(this.value).toFixed(2);
		});
	}	
}