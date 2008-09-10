var CalendarDate = Class.create({
  initialize: function(year, month, day) {
    this.date  = new Date(Date.UTC(year, month - 1));
    this.date.setUTCDate(day);
    
    this.year  = this.date.getUTCFullYear();
    this.month = this.date.getUTCMonth() + 1;
    this.day   = this.date.getUTCDate();
    this.value = this.date.getTime();
  },
  
  beginningOfMonth: function() {
    return new CalendarDate(this.year, this.month, 1);
  },
  
  beginningOfWeek: function() {
    return this.previous(this.date.getUTCDay());
  },
  
  next: function(value) {
    if (value === 0) return this;
    return new CalendarDate(this.year, this.month, this.day + (value || 1));
  },
  
  previous: function(value) {
    if (value === 0) return this;
    return this.next(-(value || 1));
  },
  
  succ: function() {
    return this.next();
  },
  
  equals: function(calendarDate) {
    return this.value == calendarDate.value;
  },
  
  isWeekend: function() {
    var day = this.date.getUTCDay();
    return day == 0 || day == 6;
  },
  
  getMonthName: function() {
    return CalendarDate.MONTHS[this.month - 1];
  },
  
  toString: function() {
    return this.stringValue = this.stringValue ||
      [this.year, this.month, this.day].invoke("toPaddedString", 2).join("-");
  }
});

Object.extend(CalendarDate, {
  MONTHS:   $w("January February March April May June July August September October November December"),
  WEEKDAYS: $w("Sunday Monday Tuesday Wednesday Thursday Friday Saturday"),
  
  parse: function(date) {
    if (!(date || "").toString().strip()) {
      return CalendarDate.parse(new Date());
      
    } else if (date.constructor == Date) {
      return new CalendarDate(date.getFullYear(), date.getMonth() + 1, date.getDate());
      
    } else if (Object.isArray(date)) {
      var year = date[0], month = date[1], day = date[2];
      return new CalendarDate(year, month, day);
      
    } else {
      return CalendarDate.parse(date.toString().split("-"));
    }
  }
});
