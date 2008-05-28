class ActiveRecord::Base
  def self.field_reader_with_default(sym, default = nil)
    define_method(sym){!self[sym].blank? ? self[sym] : default}
  end
  
  def self.acts_as_currency(*fields)
    fields.each do |fieldname|
      define_method("#{fieldname}_in_dollars") do
        (send(fieldname).to_f / 100.0) unless send(fieldname).nil?
      end

      define_method("#{fieldname}_in_dollars=") do |new_value|
        new_value = new_value.blank? ? nil : (new_value.to_f * 100.0).to_i
        send("#{fieldname}=", new_value)
      end
    end
  end
  
  def self.options_for_select(options={})
    options.reverse_merge!({
      :find  => {},
      :value => :id,
      :label => :name
    })
    find(:all, options[:find]).collect do |obj|
      [obj.send(options[:label]), obj.send(options[:value])]
    end
  end
  
end

module Practical
  module Extensions
    module ActiveRecord
      
      # Still here for backward compatibility with
      # older, pre-simply_helpful apps using this plugin
      def dom_id(prefix=nil)
        display_id = new_record? ? "new" : id
        prefix ||= self.class.name.underscore
        prefix != :bare ? "#{prefix.to_s.dasherize}_#{display_id}" : display_id
      end
    
    end
    module ActiveRecordSearch
      def search(query, fields, options = {}) 
        find :all, options.merge(:conditions => [[fields].flatten.map { |f| 
          "#{table_name}.#{f} LIKE :query"}.join(' OR '), {:query => "%#{query}%"}]) 
      end
    end
  end
end