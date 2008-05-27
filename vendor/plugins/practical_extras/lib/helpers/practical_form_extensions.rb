module ActionView
  module Helpers
    module FormHelper
      FIELD_ERROR_OPTIONS = {:tag_name => 'dd', :class => 'FormError'}
      
      def field_error(object,field,*args)
        options = args.last.is_a?(Hash) ? args.pop : {}
        options = FIELD_ERROR_OPTIONS.merge(options)
        
        if (errors = object.errors.on(field))
          error_message = case
            when errors.is_a?(String)
              errors
            when errors.is_a?(Array)
              tag(:ul, nil, true) + (errors.collect { |e| content_tag(:li, e) }).to_s + "</ul>"
          end
          
          error_message = %{#{options[:prefix]} #{error_message}} if options[:prefix]
          
          content_tag(options[:tag_name], error_message, :class => options[:class])
        else
          ""
        end
      end
      
    end
    class FormBuilder
      def field_error(method, options={})
        @template.field_error(@object, method, options)
      end
      
      def currency_field(method, options={})
        options.reverse_merge!({
          :currency => "$",
          :class => "big currency"
        })
        
        currency_symbol = @template.content_tag(:span, options.delete(:currency), :class => "currency-symbol")
        currency_symbol + text_field(method, options)
      end
      
      def select_from_current_values(method, defaults=[], options={})
        current_values = @object.class.find(:all, :select => "DISTINCT #{method.to_s}").collect(&method)
        defaults += @object.class.send("default_#{method}_options") if @object.class.respond_to?("default_#{method}_options")
        values = (current_values + defaults).uniq.sort
      
        select(method, values, options)
      end
      
      def method_missing_with_extra_magic(method_name,*args)
        if method_name.to_s =~ /_with_error$/
          fieldname = args.shift
          
          error_options =          
            if args.last.is_a?(Hash)
              args.last.delete(:error) || {}
            else
              {}
            end
          
          error_options.reverse_merge!({
            :tag_name => 'div'
          })
          
          field_error(fieldname,error_options).to_s +
          @template.content_tag(error_options[:tag_name], send(method_name.to_s.sub(/_with_error$/,""),fieldname,*args))
        else
          method_missing_without_extra_magic(method_name,*args)
        end
      end
      alias_method_chain :method_missing, :extra_magic
      
      def method_missing_with_label_and_tags(method_name, *args)
        if method_name.to_s =~ /^labeled_/
          fieldname = args.shift
          
          if args.last.is_a?(Hash)
            text = args.last.delete(:label)
          end
          
          output  = @template.content_tag(:dt, self.label(fieldname, text))
          output += @template.content_tag(:dd, send(method_name.to_s.sub(/^labeled_/,""),fieldname,*args))
          output
        else
          method_missing_without_label_and_tags(method_name,*args)
        end
      end
      alias_method_chain :method_missing, :label_and_tags
    end
    class StructuredFormBuilder < FormBuilder
      (field_helpers - %w(check_box radio_button hidden_field label)).each do |selector|
        src = <<-END_SRC
          def #{selector}(field, options={})
            text    = options.delete(:label)
            output  = @template.content_tag(:dt, self.label(field, text))
            output += @template.content_tag(:dd, super)
            output
          end
        END_SRC
        class_eval src, __FILE__, __LINE__
      end
    end
  end
end