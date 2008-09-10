require "calendar_date_select"

ActionView::Helpers::FormHelper.send(:include, CalendarDateSelect::FormHelper)
ActionView::Base.send(:include, CalendarDateSelect::FormHelper)
