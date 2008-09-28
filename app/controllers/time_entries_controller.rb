class TimeEntriesController < ApplicationController
  layout 'default'
  
  before_filter :remember_view_setting
  
  def import
    
  end
  
  def handle_import
    @importer = JournalEntry::Importer.from_file(params[:uploaded_data])
  end
  
  def index
    @journal_entries ||= JournalEntry.by_month(start_date_for_current_request).find(:all)
  end
  
  def new
    @journal_entry = JournalEntry.new(params[:journal_entry])
    #render :action => "edit"
  end
  
  def edit
    @journal_entry = JournalEntry.find(params[:id])
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
        render :update do |page|
          page["formErrors"].update ""
          page["formErrors"].hide
          #page["recent_entries"].insert_html :top, :partial => 'entry', :object => @journal_entry
          page.insert_html :top, "recent_entries", :partial => 'entry', :object => @journal_entry
        end
      }
    end
  rescue ActiveRecord::RecordInvalid
    
    respond_to do |format|
      format.html {
        render :action => "edit"
      }
      format.js {
        render :update do |page|
          page["formErrors"].update error_messages_for(:journal_entry)
          page["formErrors"].show
        end
      }
    end
    
  end
  
  def update
    @journal_entry = JournalEntry.find(params[:id])
    @journal_entry.update_attributes!(params[:journal_entry])
    
    respond_to do |format|
      format.html {
        flash[:message] = "The journal_entry '#{@journal_entry}' was successfully updated"
        #redirect_to :action => 'edit', :id => @journal_entry
      }
      format.js {
        render :action => "refresh.rjs"
      }
    end
  end
  
  def destroy
    @journal_entry = JournalEntry.destroy(params[:id])
    
    respond_to do |format|
      format.html {
        flash[:message] = "The journal_entry '#{@journal_entry}' was successfully destroyed"
        redirect_to :action => 'index'
      }
      format.js {
        render :update do |page|
          page[@journal_entry].remove
        end
      }
    end
  end
  
protected

  def remember_view_setting
    # Setting param, if not present, to session value or default
    params[:group_by] ||= (session[:group_by] || "day")
    
    # Remember view setting
    session[:group_by] = params[:group_by]
  end

end
