module Practical
  module LightboxHelper
    
    def lightbox_tag(options={})
      options.reverse_merge!({
        :name => 'mybox',
        :tag  => 'div',
        :content => '&nbsp;'
      })
      
      content_tag(options[:tag], options[:content], :id => options[:name], :style => "display:none")
    end
    
    def link_to_lightbox(text,url,options={})
      method = (options.delete(:method) || :get)
      
      default_url_options = {:method => method, :update => 'mybox', :complete => %{new Lightbox.base('mybox',{closeOnOverlayClick:true})}, :with => "'format=lightbox&return_to=#{request.request_uri}'"}
      
      url_options =
        case url
          when Hash then default_url_options.merge(url)
          else default_url_options.merge(:url => url)
        end
            
      link_to_remote text, url_options, options
    end
    
  end
end