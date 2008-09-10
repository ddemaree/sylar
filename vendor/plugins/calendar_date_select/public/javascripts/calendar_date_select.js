var CalendarDateSelect = Class.create({
  initialize: function(field, options) {
    this.field   = $(field);
    this.options = options || {};

    this.setDate(CalendarDate.parse($F(field)));
    this.setCursor(this.date);

    this.createElement();
    this.field.insert({ after: this });
  },
  
  createElement: function() {
    this.element = new Element("div", { className: "calendar_date_select" });
    
    this.header = new Element("div", { className: "header" });
    this.pager = new CalendarDateSelect.Pager(this.cursor);
    this.header.insert(this.pager);
    this.element.insert(this.header);
    
    this.body = new Element("div", { className: "body" });
    this.updateBody();
    this.element.insert(this.body);
    
    this.footer = new Element("div", { className: "footer" });
    this.title = new Element("span").update((this.options.title || "Due:") + " ");
    this.description = new Element("span");
    this.updateDescription();
    this.footer.insert(this.title);
    this.footer.insert(this.description);
    this.element.insert(this.footer);
    
    this.element.observe("calendar:cursorChanged", this.onCursorChanged.bind(this));
    this.element.observe("calendar:dateSelected", this.onDateSelected.bind(this));
  },
  
  onCursorChanged: function(event) {
    this.setCursor(event.memo.cursor);
  },
  
  onDateSelected: function(event) {
    this.setDate(event.memo.date);
  },
  
  setCursor: function(date) {
    this.cursor = date.beginningOfMonth();
    this.updateBody();
  },
  
  setDate: function(date) {
    this.date = date;
    this.field.setValue(this.date);
    this.updateDescription();
  },
  
  updateBody: function() {
    if (this.body) {
      this.grid = new CalendarDateSelect.Grid(this.date, this.cursor);
      this.body.update(this.grid);
    }
  },
  
  updateDescription: function() {
    if (this.description) {
      this.description.update("#{month} #{day}, #{year}".interpolate({
        month: this.date.getMonthName(), day: this.date.day, year: this.date.year
      }));
    }
  },
  
  toElement: function() {
    return this.element;
  }
});


CalendarDateSelect.Pager = Class.create({
  initialize: function(cursor) {
    this.cursor = cursor;
    this.createElement();
  },
  
  createElement: function() {
    this.element = new Element("div", { className: "pager" });
    
    this.left = new Element("a", { href: "#", className: "nav left", method: "previous" });
    this.left.update("<<".escapeHTML());
    this.left.observe("click", this.onButtonClicked.bind(this));
    this.element.insert(this.left);
    
    this.right = new Element("a", { href: "#", className: "nav right", method: "next" });
    this.right.update(">>".escapeHTML());
    this.right.observe("click", this.onButtonClicked.bind(this));
    this.element.insert(this.right);
    
    this.select = new Element("select", { className: "months" });
    this.updateSelect();
    this.select.observe("change", this.onSelectChanged.bind(this));
    this.element.insert(this.select);
  },
  
  onButtonClicked: function(event) {
    var element = event.findElement("a[method]");
    if (element) {
      this[element.readAttribute("method")]();
      event.stop();
    }
  },
  
  onSelectChanged: function(event) {
    this.setCursor(CalendarDate.parse($F(this.select)));
  },
  
  previous: function() {
    this.setCursor(this.cursor.beginningOfMonth().previous());
  },
  
  next: function() {
    this.setCursor(new CalendarDate(this.cursor.year, this.cursor.month + 1, 1));
  },
  
  setCursor: function(cursor) {
    cursor = cursor.beginningOfMonth();
    var event = this.element.fire("calendar:cursorChanged", { cursor: cursor });
    
    if (!event.stopped) {
      var oldCursor = this.cursor;
      this.cursor = cursor;
      this.updateSelect(oldCursor);
    }
  },
  
  updateSelect: function(oldCursor) {
    if (!oldCursor || this.cursor.year != oldCursor.year) {
      this.months = this.getDatesForSurroundingMonths();
      this.select.options.length = 0;
      this.getDatesForSurroundingMonths().each(function(date, index) {
        var title = [date.getMonthName().slice(0, 3), date.year].join(" ");
        this.select.options[index] = new Option(title, date.toString());
        if (this.cursor.equals(date)) this.select.selectedIndex = index;
      }, this);
      
    } else {
      this.select.selectedIndex = this.months.pluck("value").indexOf(this.cursor.value);
    }
  },
  
  getDatesForSurroundingMonths: function() {
    return $R(this.cursor.year - 1, this.cursor.year + 2).map(function(year) {
      return $R(1, 12).map(function(month) {
        return new CalendarDate(year, month, 1);
      });
    }).flatten();
  },

  toElement: function() {
    return this.element;
  }
});


CalendarDateSelect.Grid = Class.create({
  initialize: function(date, cursor) {
    this.date    = CalendarDate.parse(date);
    this.cursor  = CalendarDate.parse(cursor).beginningOfMonth();
    this.today   = CalendarDate.parse();

    this.createElement();
  },
  
  createElement: function() {
    var table = new Element("table");
    var tbody = new Element("tbody");
    var html  = [];
    
    html.push('<tr class="weekdays">');
    CalendarDate.WEEKDAYS.each(function(weekday) {
      html.push("<th>", weekday[0], "</th>");
    });
    html.push("</tr>");
    
    this.getWeeks().each(function(week) {
      html.push('<tr class="days">');
      week.each(function(date) {
        html.push('<td class="', this.getClassNamesForDate(date).join(" "));
        html.push('" date="', date, '"><a href="#">', date.day, "</a></td>");
      }, this);
      html.push("</tr>");
    }, this);

    tbody.insert(html.join(""));
    table.insert(tbody);
    table.observe("click", this.onDateClicked.bind(this));
    
    return this.element = table;
  },
  
  getStartDate: function() {
    return this.cursor.beginningOfWeek();
  },
  
  getEndDate: function() {
    return this.getStartDate().next(41);
  },
  
  getDates: function() {
    return $R(this.getStartDate(), this.getEndDate());
  },
  
  getWeeks: function() {
    return this.getDates().inGroupsOf(7);
  },
  
  getClassNamesForDate: function(date) {
    var classNames = [];

    if (date.equals(this.today)) classNames.push("today");
    if (date.equals(this.date))  classNames.push("selected");
    if (date.isWeekend())        classNames.push("weekend");
    if (!date.beginningOfMonth().equals(this.cursor))
      classNames.push("other");
    
    return classNames;
  },
  
  onDateClicked: function(event) {
    var element = event.findElement("td[date]");
    if (element) {
      this.selectDate(element);
      event.stop();
    }
  },
  
  selectDate: function(element) {
    var date  = CalendarDate.parse(element.readAttribute("date"));
    var event = element.fire("calendar:dateSelected", { date: date });
    
    if (!event.stopped) {
      var selection = this.element.down("td.selected");
      if (selection) selection.removeClassName("selected");
    
      this.selectedElement = element;
      this.date = date;

      element.addClassName("selected");
    }
  },
  
  toElement: function() {
    return this.element;
  }
});
