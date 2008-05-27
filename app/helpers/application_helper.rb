module ApplicationHelper
  
  def system_message_class
    flash[:alert] ? "alert" : "message"
  end
  
  def nav_item(text,url,key=nil)
    key  ||= text.downcase.to_sym
    
    nav_is_active = case key
      when TrueClass, FalseClass then key
      when Symbol then !!(section_name.to_sym == key.to_sym)
      when String then !!(body_id.to_sym == key.to_sym) 
    end
    
    text   = content_tag(:span, text)
    link   = link_to(text, url)
    
    content_tag(:li, link, :class => ("active" if nav_is_active))
  end
  
end
