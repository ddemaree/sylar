module PracticalHelper
  
  def link_to_nothing(link_text, options={})
    link_to(link_text, "javascript:void%200", options)
  end
  
  # link_to_delete ""
  def link_to_delete(link_text,options={},html_options={})
    options = {
      :with => %{'_method=delete'},
      :confirm => %{Are you sure you want to delete this item?\nWarning: there is no undo.}
    }.merge(options)
    
    html_options = {
      :href => 'javascript:void%200'
    }.merge(html_options)
    
    link_to_remote(link_text,options,html_options)
  end
  
  def fieldset(options={},&block)
    legend_text = options.delete(:legend)
    include_dl  = options.delete(:dl)
    set_content = capture(&block)
    
    if include_dl
      dl_options = include_dl.is_a?(Hash) ? include_dl : {}
      dl_options[:class] = "form-fields #{dl_options[:class]}".strip
      set_content = content_tag(:dl, set_content, dl_options)
    end
    
    set_content = (content_tag(:legend, legend_text) + set_content) if legend_text
    
    concat(content_tag(:fieldset, set_content, options), block.binding)
  end
  
  def content_tags_for(tag_name, collection, *args, &block)
    raise Exception, "expected Array, got #{collection.class}" unless collection.is_a?(Array)
    
    prefix  = args.first.is_a?(Hash) ? nil : args.shift
    options = args.first.is_a?(Hash) ? args.shift : {}
    cycles  = options.delete(:cycle)
    
    collection.each do |object|
      member_options = options.merge({
        :id => dom_id(object, prefix),
        :class => pe_class_names_for(object, options[:class])
      })
      
      if cycles
        member_options[:class] = "#{member_options[:class]} #{cycle(*cycles)}".strip
      end
      
      concat(tag(tag_name, member_options, true), block.binding)
      yield object
      concat("</#{tag_name.to_s}>", block.binding)
    end
  end
  
  def pe_class_names_for(object, class_param=nil)
    returning "" do |class_names|
      class_names << dom_class(object)
      
      case class_param
        when Symbol
          class_names << " #{send(class_param, object)}"
        when String
          class_names << " #{class_param}"
      end
    
    end
  end

  def markdown_link
    "<a href=\"http://daringfireball.net/projects/markdown\" target=\"_blank\">Markdown</a>"
  end

  def clearing(options={})
    options.reverse_merge!({
      :tag => 'div',
      :nbsp => false
    })
    
    content_tag options[:tag], (options[:nbsp] ? "&nbsp;" : ""), :style => 'clear:both;display:block'
  end
  
  def html_editor_with_preview(field_name="",field_value="")
    res  = "<ul id=\"PreviewTabs\">"
    res += "<li class=\"tab on\" id=\"EditTab\"><a href=\"#\" id=\"EditLink\">Edit</a></li>"
    res += "<li class=\"tab\" id=\"PreviewTab\"><a href=\"#\" id=\"PreviewLink\">Preview</a></li>"
    res += "<div style=\"clear:both\"></div>"
    res += "</ul>"
    res += content_tag 'div', text_area_tag(field_name, field_value.to_s.gsub(/\&/,"&amp;"), {:rows => '20', :class => 'StandardTextArea StandardField', :id => 'EditorText'}), :id => 'EditorBox', :class => 'PreviewBoxBasic'
    res += content_tag('div',content_tag('div','&nbsp;',:id => 'PreviewBoxContents', :onclick => 'switchToEditor();'), :id => 'PreviewBox', :class => 'PreviewBoxBasic',:style => 'display:none')
    res += "<div id=\"PreviewInfo\" class=\"label\" style=\"margin-top: 3px;\">"
    res += "You can use <a href=\"http://daringfireball.net/projects/markdown\" target=\"_blank\">Markdown</a> formatting or plain HTML to style this text."
    res += "</div>"
    res += content_tag('script', 'createLiveEditor();', :type => 'text/javascript')
    res += hidden_field_tag 'preview_ajax_url', url_for(:controller => 'articles', :action => 'preview_html'), :id => 'preview_ajax_url'
  end
  
end