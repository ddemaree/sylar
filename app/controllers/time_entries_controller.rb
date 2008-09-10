class TimeEntriesController < ApplicationController
  layout 'default2'
  
  before_filter :remember_view_setting
  
  def index
    @journal_entries ||= JournalEntry.by_month(start_date_for_current_request)
  end
  
  def new
    render :action => "edit"
  end
  
  def edit
    
  end
  
protected

  def remember_view_setting
    # Setting param, if not present, to session value or default
    params[:group_by] ||= (session[:group_by] || "day")
    
    # Remember view setting
    session[:group_by] = params[:group_by]
  end

end
