module CrumbSaver
  
  def self.included(base)
    base.class_eval do
      before_filter :setup_breadcrumbs
      define_method(:breadcrumbs) { @breadcrumbs ||= [] }
      helper_method :breadcrumbs
    end
  end
  
  def setup_breadcrumbs
    @breadcrumbs = breadcrumbs    
  end
  
  # def breadcrumbs
  #   @breadcrumbs ||= [["Application", "/"]]
  # end
  
end