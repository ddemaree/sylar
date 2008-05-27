# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  include AuthenticatedSystem
  layout 'default'
  helper :all
  protect_from_forgery
  
  before_filter :login_required
  before_filter :set_current_user
  
  rescue_from ActiveRecord::RecordInvalid do |exception|
    flash.now[:alert] = "There appears to be a problem."
    render :action => "edit"
  end
  
  def set_current_user
    JournalEntry.current_user = current_user if logged_in?
  end
  
  def system_message
    flash[:message] || flash[:alert] || params[:system_message]
  end
  helper_method :system_message
  
end
