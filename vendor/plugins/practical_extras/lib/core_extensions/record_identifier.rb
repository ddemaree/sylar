module ActionView
  module Helpers
    module RecordTagHelper
      def list_item_for(record, *args, &block)
        content_tag_for(:li, record, *args, &block)
      end
    end
  end
end

# Adding ability to override SH's default partial and route
# naming by adding a to_class_name method to an AR model,
# same as how you can customize the default URL generation
# for a given model with to_param
module ActionController
  module RecordIdentifier
  
    def partial_path_with_override(record_or_class, controller_path=nil)
      if defined?(record_or_class.partial_path)
        record_or_class.partial_path || partial_path_without_override(record_or_class, controller_path)
      elsif defined?(record_or_class.resource_name)
        pp = record_or_class.resource_name
        "#{pp.tableize}/#{pp}"
      else
        partial_path_without_override(record_or_class)
      end
    end
    
    alias_method_chain :partial_path, :override
  
    def singular_class_name_with_override(record_or_class)
      if defined?(record_or_class.resource_name) && record_or_class.resource_name
        record_or_class.resource_name
      else
        singular_class_name_without_override(record_or_class)
      end
    end
    
    alias_method_chain :singular_class_name, :override
  
  end
end