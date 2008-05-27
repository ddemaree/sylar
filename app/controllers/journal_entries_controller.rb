class JournalEntriesController < ApplicationController
  
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
  
  def update
    @journal_entry = JournalEntry.find(params[:id])
    @journal_entry.update_attributes!(params[:journal_entry])
    
    respond_to do |format|
      format.html {
        flash[:message] = "The journal_entry '#{@journal_entry}' was successfully updated"
        redirect_to :action => 'edit', :id => @journal_entry
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
        render :action => "refresh.rjs"
      }
    end
  end
  
  def journal_entries_for_index
    @journal_entries ||= JournalEntry.current_month
  end
  helper_method :journal_entries_for_index

end
