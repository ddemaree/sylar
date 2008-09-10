module CalendarDateSelect
  module FormHelper
    def calendar_date_select_tag(name, value = nil, options = {})
      value = value.to_date.to_s
      id = options[:id] || name.gsub(/\[(.*?)\]/, "_\\1")
      
      returning "" do |html|
        html << hidden_field_tag(name, value, options.merge(:id => id))
        html << javascript_tag("new CalendarDateSelect(#{id.to_json}, #{options.to_json});")
      end
    end
    
    def calendar_date_select(object, method, options = {})
      record = instance_eval("@#{object}")
      name   = "#{object}[#{method}]"
      value  = record.send(method)
      
      calendar_date_select_tag(name, value, options)
    end  
  end
end


module ActionView
  module Helpers
    class FormBuilder
      def calendar_date_select(method, options = {})
        @template.calendar_date_select(@object_name, method, options.merge(:object => @object))
      end
    end
  end
end
