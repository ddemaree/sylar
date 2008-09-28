class AccountsController < ApplicationController
  layout 'public'
  
  skip_before_filter :find_account, :only => [:new, :create]
  skip_before_filter :login_required, :only => [:new, :create]
  
  def new
    @account = Account.new(params[:account])
  end

end
