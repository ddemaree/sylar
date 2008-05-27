# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  include AuthenticatedSystem
  layout 'sylar'
  helper :all
  protect_from_forgery
  
  before_filter :login_required
  
  rescue_from ActiveRecord::RecordInvalid do |exception|
    flash.now[:alert] = "There appears to be a problem."
    render :action => "edit"
  end
  
  def system_message
    flash[:message] || flash[:alert] || params[:system_message]
  end
  helper_method :system_message
  
end
