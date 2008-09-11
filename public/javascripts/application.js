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

TickTock = {
	hideAll: function(){
		$jq(".modal").animate({
			opacity: 0.0
		}, 500, null, function(){
			$(this).hide();
		})
	},
	showInlineEntry: function(){
		
		$jq(".modal").css({
			display: "block",
			opacity: 0.0
		})
		$jq("#inline_entry").css({
			top: (window.pageYOffset - 150)
		});
		$jq("#inline_entry").animate({ 
			display: "block",
			opacity: 1.0,
			top: (window.pageYOffset + 50)
		}, 500 );
		
		$jq("#overlay").animate({
			display: "block",
			opacity: 0.6
		}, 500);
		
		return false;
	},
	hideInlineEntry: function(){
		$jq("#inline_entry").animate({ 
			display: "none",
			opacity: 0,
			top: "30px"
		}, 300 );
		
		$jq("#overlay").animate({
			display: "block",
			opacity: 0.0
		}, 300);
	}
}

$jq(document).ready(function(){
	$jq(".modal").css({
		display: "none",
		opacity: 0.0
	});
	$jq("#overlay").click(TickTock.hideAll);
	$jq("#add_entry_link").click(TickTock.showInlineEntry);
	
	$jq(window).scroll(function(){
		$jq("#overlay").css({
			top: window.pageYOffset
		})
		
		$jq("#inline_entry").css({
			top: window.pageYOffset + 50
		})
		
		return false;
	});
	
	$jq("#inline_entry form").submit(function(){
		$jq.ajax({
			type: "POST",
			url: "/journal_entries.js",
			data: $jq(this).serialize(),
			dataType: "html",
			success: function(data, responseType){
				alert("Succeeded!");
			},
			error: function(data, rT){
				alert("Failed! " + data.responseText);
			}
		})
		return false;
	})
});