module ApplicationHelper
  
  def system_message_class
    flash[:alert] ? "alert" : "message"
  end
  
  def is_current(key,value,active_value="current")
    (params[key] == value) ? active_value : nil
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
  
  def group_by_date_with_empties(collection, options={})
    base_set = collection.group_by(&:date)
    days = (Date.today.beginning_of_month..Date.today).inject({}) { |c, d| c[d] = []; c }
    days.update(base_set).sort { |a, b| b[0] <=> a[0] }
  end
  
  
  def url_params_for(new_params={})
    @url_params = { :escape => false }.merge(new_params)
    stringified_merge @url_params, params
    url_for(@url_params)
  end
  
  def stringified_merge(target, other)
    other.each do |key, value|
      key = key.to_s
      existing = target[key]

      if value.is_a?(Hash)
        target[key] = existing = {} if existing.nil?
        if existing.is_a?(Hash)
          stringified_merge(existing, value)
          return
        end
      end
      
      target[key] = value
    end
  end
  
end
