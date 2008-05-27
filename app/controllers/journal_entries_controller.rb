class JournalEntriesController < ApplicationController
  
  def index
    @journal_entries = JournalEntry.find(:all, :order => "date DESC")
  end
  
  def new
    @journal_entry = JournalEntry.new(params[:journal_entry])
    render :action => 'edit'
  end
  
  def create
    @journal_entry = JournalEntry.new(params[:journal_entry])
    @journal_entry.save!
    flash[:message] = "The new journal_entry '#{@journal_entry}' was successfully added"
    redirect_to :action => 'edit', :id => @journal_entry
  end

  def edit
    @journal_entry = JournalEntry.find(params[:id])
  end
  
  def update
    @journal_entry = JournalEntry.find(params[:id])
    @journal_entry.update_attributes!(params[:journal_entry])
    flash[:message] = "The journal_entry '#{@journal_entry}' was successfully updated"
    redirect_to :action => 'edit', :id => @journal_entry
  end

end
