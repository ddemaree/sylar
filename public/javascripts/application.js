Element.addMethods({
	jq: function(element){
		return $jq(element)
	}
})

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

// Yes, I'm mixing jQuery and Prototype what
var DatePager = Class.create({
  initialize: function(id){
		this.field = $(id)
		if($F(this.field).blank()) {
			console.log("Field is blank, populate with today's date")
			this.field.value = CalendarDate.parse(new Date()).toString();
		}
		
		theDate = CalendarDate.parse($F(this.field))
		this.cursor = theDate.beginningOfWeek()
		
		this.createElement()
		this.field.insert({after:this})
		
		this.setDate(theDate)
		
		this.element.observe("pdp:cursorChanged", this.onCursorChanged.bind(this));
		this.element.observe("pdp:dateSelected", this.onDateSelected.bind(this));
	},
	
	onCursorChanged: function(event) {
		this.setCursor(event.memo.cursor);
	},

	onDateSelected: function(event) {
		this.setDate(event.memo.date);
	},
	
	setCursor: function(date){
		oldCursor = this.cursor
		this.cursor = date;
		
		animationOffset = (oldCursor < this.cursor) ? -370 : 370;
		
		console.log(animationOffset)
		this.body.makePositioned()
		this.body.jq().animate(
			{left: animationOffset},
			250,
			null,
			function(){
				this.updateBody()
			}.bind(this)
		)
	},
	
	setDate: function(date){
		this.selectedDate = date;
		
		this.field.value = this.selectedDate.toString()
		console.log("Selected: " + $F(this.field))
		this.element.down('h4').update(
			"Selected: <strong>#{month} #{day}, #{year}</strong>".interpolate({
				month: date.getMonthName(),
				day:   date.day,
				year:  date.year
			})
		)
	},
	
	createElement: function(){
		this.element = new Element('div',{'id':'dpw'})
		
		this.header = new Element("div", { 'class': "header" });
		this.element.insert(this.header);
		
		this.title = new Element('h4',{'class':'title'}).update("Selected: ")
		this.header.insert({top:this.title})
		
		this.title.observe('dblclick',function(e){
			this.setCursor(this.selectedDate);
		}.bind(this))
		
		this.pager = new DatePager.Pager(this.cursor)
		this.header.insert(this.pager)
		
		this.body = new Element('ul',{'class':'bd'})
		this.updateBody()		
		this.element.insert(this.body)
		this.body.wrap('div',{'class':'track'})
		
		this.element.jq().hover(
			function(){
				$jq('#dpw a.nav').fadeIn(500)
			},
			function(){
				$jq('#dpw a.nav').fadeOut(500)
			}
		)
	},
	toElement: function() {
		return this.element;
	},
	startDate: function() {
		return this.cursor.beginningOfWeek()
	},
	endDate: function() {
		return this.startDate().next(6)
	},
	dayElement: function(day){
		newDay = new Element("li")
		newDay.update(
			"<strong>#{dayname}</strong><span>#{date}</span>".interpolate({
				dayname: day.getShortDayName(),
				date:    (day.date.getUTCMonth() + 1) + "/" + day.date.getUTCDate()
			})
		)
		newDay.setAttribute("date", day)

		if(day.equals(this.selectedDay())) newDay.addClassName("selected");
		if(day.equals(this.today())) newDay.addClassName("today");

		newDay.observe('click',this.selectDay)

		return newDay;
	},
	
	selectDay: function(){
		var date  = CalendarDate.parse(this.readAttribute("date"));
		var event = this.fire("pdp:dateSelected", { date: date });
		
		if (!event.stopped) {
			this.up('ul').select('li').invoke('removeClassName','selected')
			this.addClassName("selected")
		}
		
	},
	
	updateBody: function(){
		this.body.setStyle({left:0})
		this.body.update("")
		
		$R(this.startDate(), this.endDate()).each(function(day){
			this.body.insert(this.dayElement(day))
		}.bind(this));		
	},
	
	thisWeek: function(){
		this.date = CalendarDate.parse(new Date());
		this.populate()
	},
	today: function(){
		return CalendarDate.parse(new Date());
	},
	selectedDay: function(){
		return CalendarDate.parse(this.field.value);
	}
})

DatePager.Pager = Class.create({
	initialize: function(cursor){
		this.cursor = cursor
		this.createElement()
	},
	createElement: function(){
		this.element = new Element('div',{'class':'pager'})
		
		this.left = new Element("a", { href: "#", className: "nav left", method: "previous" });
		this.left.update("<<".escapeHTML());
		this.left.observe("click", this.onButtonClicked.bind(this));
		this.element.insert(this.left);

		this.right = new Element("a", { href: "#", className: "nav right", method: "next" });
		this.right.update(">>".escapeHTML());
		this.right.observe("click", this.onButtonClicked.bind(this));
		this.element.insert(this.right);
		
		//this.element.select("a").invoke('hide')
	},
	toElement: function() {
		return this.element;
	},
	
	onButtonClicked: function(e){
		if(link = e.findElement("a[method]")) {
			this[link.getAttribute("method")]()
		}
		return false;
	},
	
	setCursor: function(cursor){
		cursor = cursor.beginningOfWeek();
		var event = this.element.fire("pdp:cursorChanged", { cursor: cursor });
		if (!event.stopped) {
			var oldCursor = this.cursor;
			this.cursor = cursor;
			//this.updateSelect(oldCursor);
		}
	},
	
	previous: function(){
		console.log("Scroll to prev week")
		this.setCursor(this.cursor.previous(7))
	},
	
	next: function(){
		console.log("Scroll to next week")
		this.setCursor(this.cursor.next(7))
	}
})

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
				//alert("Succeeded!");
				$jq(this).reset();
			},
			error: function(data, rT){
				alert("Failed! " + data.responseText);
			}
		})
		return false;
	})
});

ClientPicker = Class.create({
	initialize: function(clientField, trackableField, clientObjs){
		this.init = true
		this.clientField    = $(clientField)
		this.trackableField = $(trackableField)
		
		this.clients        = clientObjs || [];
	
		this.createElement()
		this.trackableField.insert({after:this})
		
		this.element.observe("pcp:rowSelected", this.handleRowSelection.bind(this));
		
		this.populateClients()
		this.init = false
	},
	createElement: function(){
		this.element = new Element('div',{'class':'pickpock'})
		
		this.clientPicker = new Element('div',{'class':'pickbox clients'})
		this.element.insert(this.clientPicker)
		this.element.scrollTo(0,50);
		
		this.trackablePicker = new Element('div',{'class':'pickbox trackables'})
		this.element.insert(this.trackablePicker)
		
		this.element.insert('<hr>')	
	},
	toElement: function(){
		return this.element;
	},
	
	createRow: function(client_or_trackable){
		rowElem = new Element('div')
		
		// Subject is a client
		if(client_or_trackable.name){
			client = client_or_trackable
			rowElem.update(client.name)
			
			rowElem.writeAttribute({
				"id":          "client_" + client.id,
				"clientid":    client.id,
				"trackableid": client.trackable_id,
				"subjectname": client.name,
				"rate":        client.rate
			})
		}
		// Subject is a trackable
		else {
			trackable = client_or_trackable
			rowElem.update(trackable.subject_name)
			
			rowElem.writeAttribute({
				"id":          "trackable_" + trackable.id,
				"trackableid": trackable.id,
				"subjectname": trackable.subject_name,
				"rate":        trackable.rate
			})
		}
		
		rowElem.observe('click',function(){
			//var date  = CalendarDate.parse(this.readAttribute("date"));
			var event = this.fire("pcp:rowSelected", {});

			if (!event.stopped) {
				console.log('clicky!')
			}
		})
		
		return rowElem;
	},
	
	handleRowSelection: function(e){
		console.log('selected!')
		
		element = e.element()

		t_id = element.readAttribute("trackableid")
		this.trackableField.value = t_id
		
		// if(!this.init){
		// 			
		// 		}

		this.element.select(".selected").invoke('removeClassName', 'selected')
		element.addClassName('selected')

		rate_in_dollars = (Number(element.readAttribute("rate")) / 100).toFixed(2)
		$('rate').value = rate_in_dollars
		
		// If client
		if(clientId = element.readAttribute('clientid')){
			this.element.select("div").invoke('removeClassName', 'selectedclient')
			element.addClassName('selectedclient')

			this.clientField.value = clientId
			this.trackablePicker.update("")
			
			trackables = this.findTrackables(clientId);
			
			if(trackables){
				console.log("Ready to populate trackables")
				this.populateTrackables(trackables)
			}
		}	
	},
	
	populateClients: function(){
		this.clients.each(function(client){
			this.clientPicker.insert(this.createRow(client))
		}.bind(this))
		
		if(!$F(this.clientField).blank()){
			clientRow = $('client_' + $F(this.clientField))
			clientRow.fire("pcp:rowSelected")
		}
	},
	
	populateTrackables: function(rows){
		rows.each(function(row){
			if(row.subject_type == "Client") return;
			console.log("Trackable! " + row)
			this.trackablePicker.insert(this.createRow(row))
		}.bind(this))
		
		if(!$F(this.trackableField).blank()){
			trRow = $('trackable_' + $F(this.trackableField))
			trRow.fire("pcp:rowSelected")
		}
	},
	
	findTrackables: function(clientId){
		clientId = Number(clientId);
		trackables = false;
		this.clients.each(function(clientObj){
			if(clientId == clientObj.id){
				trackables = clientObj.trackables;
			}
		});
		return trackables;
	}

});