# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  include AuthenticatedSystem
  include CrumbSaver
  
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
    Task.current_user = current_user if logged_in?
  end
  
  def section_name
    controller_name.to_sym
  end
  helper_method :section_name
  
  def system_message
    flash[:message] || flash[:alert] || params[:system_message]
  end
  helper_method :system_message
  
  def current_parent
    
  end
  helper_method :current_parent
  
  def current_period
    @current_period ||= Period.find_or_create_by_year_and_month(start_date.year, start_date.month)
  end
  helper_method :current_period
  
  def start_date_for_current_request
    params[:year]  ||= Date.today.year
    params[:month] ||= Date.today.month

    @start_date_for_current_request ||= Date.new(params[:year].to_i, params[:month].to_i)
  end
  alias_method :start_date, :start_date_for_current_request
  helper_method :start_date_for_current_request
  helper_method :start_date
  
  def current_month?
    !!(start_date == Date.today.beginning_of_month)
  end
  helper_method :current_month?
  
  
end
