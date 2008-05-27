class <%= controller_class_name %>Controller < ApplicationController
  
  rescue_from ActiveRecord::RecordInvalid do |exception|
    render :action => 'edit'
  end
  
  def index
    @<%= model_plural %> = <%= model_class_name %>.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @<%= model_plural %> }
    end
  end

  def show
    @<%= model_singular %> = <%= model_class_name %>.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @<%= model_singular %> }
    end
  end

  def new
    @<%= model_singular %> = <%= model_class_name %>.new(params[:<%= model_singular %>])

    respond_to do |format|
      format.html { render :action => 'edit' } # edit.html.erb
      format.xml  { render :xml => @<%= model_singular %> }
    end
  end

  def edit
    @<%= model_singular %> = <%= model_class_name %>.find(params[:id])
  end

  def create
    @<%= model_singular %> = <%= model_class_name %>.new(params[:<%= model_singular %>])
    @<%= model_singular %>.save!
    flash[:message] = "Your changes were saved!"
    redirect_to(@<%= model_singular %>)
  rescue ActiveRecord::RecordInvalid
    render :action => 'edit'
  end

  def update
    @<%= model_singular %> = <%= model_class_name %>.find(params[:id])
    @<%= model_singular %>.update_attributes!(params[:<%= model_singular %>])
    flash[:message] = "Your changes were saved!"
    redirect_to(@<%= model_singular %>)
  rescue ActiveRecord::RecordInvalid
    render :action => 'edit'
  end

  def destroy
    @<%= model_singular %> = <%= model_class_name %>.find(params[:id])
    @<%= model_singular %>.destroy

    respond_to do |format|
      format.html { redirect_to(<%= model_plural %>_url) }
      format.xml  { head :ok }
    end
  end
end
