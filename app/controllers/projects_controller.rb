class ProjectsController < ApplicationController
  
  def index
    @projects = Project.find(:all, :order => "name ASC")
  end
  
  def new
    @project = Project.new(params[:project])
    render :action => 'edit'
  end
  
  def create
    @project = Project.new(params[:project])
    @project.save!
    flash[:message] = "The new project '#{@project}' was successfully added"
    redirect_to :action => 'edit', :id => @project
  end

  def edit
    @project = Project.find(params[:id])
  end
  
  def update
    @project = Project.find(params[:id])
    @project.update_attributes!(params[:project])
    flash[:message] = "The project '#{@project}' was successfully updated"
    redirect_to :action => 'edit', :id => @project
  end

end
