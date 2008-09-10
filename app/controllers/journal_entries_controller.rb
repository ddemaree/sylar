class JournalEntriesController < ApplicationController
  
  before_filter :handle_view_switching
  
  def index

  end
  
  def new
    @journal_entry = JournalEntry.new(params[:journal_entry])
    render :action => 'edit'
  end
  
  def create
    @journal_entry = JournalEntry.new(params[:journal_entry])
    @journal_entry.save!
    
    respond_to do |format|
      format.html {
        flash[:message] = "The new journal_entry '#{@journal_entry}' was successfully added"
        redirect_to :action => 'edit', :id => @journal_entry
      }
      format.js {
        render :action => "refresh.rjs"
      }
    end
  end

  def edit
    @journal_entry = JournalEntry.find(params[:id])
  end
  

  
  def destroy
    @journal_entry = JournalEntry.destroy(params[:id])
    
    respond_to do |format|
      format.html {
        flash[:message] = "The journal_entry '#{@journal_entry}' was successfully destroyed"
        redirect_to :action => 'index'
      }
      format.js {
        render :action => "refresh.rjs"
      }
    end
  end
  
protected



  def handle_view_switching
    unless session[:view_mode]
      session[:view_mode] = (params[:mode] ||= "daily")
    end
    
    session[:view_mode] = params[:mode] if params[:mode]
  end
  
  def journal_entries_for_index
    #@journal_entries ||= JournalEntry.grouped_by_day(start_date_for_current_request)
    @journal_entries ||= JournalEntry.by_month(start_date_for_current_request)
  end
  helper_method :journal_entries_for_index
  
  def total_hours_for_index
    @total_hours ||= JournalEntry.by_month(start_date_for_current_request).sum(:hours)
  end
  helper_method :total_hours_for_index
  


end
