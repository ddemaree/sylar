class ClientsController < ApplicationController
  
  def index
    @clients = Client.find(:all, :order => "name ASC")
  end
  
  def new
    @client = Client.new(params[:client])
    render :action => 'edit'
  end
  
  def create
    @client = Client.new(params[:client])
    @client.save!
    flash[:message] = "The new client '#{@client}' was successfully added"
    redirect_to :action => 'edit', :id => @client
  end

  def edit
    @client = Client.find(params[:id])
  end
  
  def update
    @client = Client.find(params[:id])
    @client.update_attributes!(params[:client])
    flash[:message] = "The client '#{@client}' was successfully updated"
    redirect_to :action => 'edit', :id => @client
  end

end
