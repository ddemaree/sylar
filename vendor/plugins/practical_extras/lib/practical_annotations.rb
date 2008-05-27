require 'source_annotation_extractor'

class PracticalAnnotations < SourceAnnotationExtractor

  def find(dirs=%w(app lib test public/stylesheets public/javascripts))    
    dirs.inject({}) { |h, dir| h.update(find_in(dir)) }
  end

  def find_in(dir)
    results = {}

    Dir.glob("#{dir}/*") do |item|
      next if File.basename(item)[0] == ?.

      if File.directory?(item)
        results.update(find_in(item))
      elsif item =~ /\.(builder|(r(?:b|xml|js)))$/
        results.update(extract_annotations_from(item, /#\s*(#{tag}):?\s*(.*)$/))
      elsif item =~ /\.(rhtml|erb)$/
        results.update(extract_annotations_from(item, /<%\s*#\s*(#{tag}):?\s*(.*?)\s*%>/))
      elsif item =~ /\.(css)$/
        results.update(extract_annotations_from(item, /\/\*\s*(#{tag}):?\s*(.*?)\s*\*\//))
        #results.update("FOUND CSS FILE AT LEAST")
      end
    end

    results
  end

end