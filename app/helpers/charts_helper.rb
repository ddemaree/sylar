require 'gchart'

module ChartsHelper
  
  def daily_productivity_graph(options={})
    options.reverse_merge!({
      :height => 500,
      :width => 200
    })
    
    dataset = Analyzer.hours_by_day(journal_entries_for_index)
    
    values  = dataset.collect(&:last)
    labels  = dataset.collect(&:first)
    
    chart =
      GChart.bar do |chart|
        chart.data = [values, Array.new(values.length, 6.0)]
        chart.colors = ["999999", "f5f5f5", :green]
        
        chart.orientation = :horizontal
        chart.width  = options[:width]
        chart.height = ((values.length * 13) + 5)
        chart.thickness = 12
        chart.spacing = 1
      end
    
    image_tag chart.to_url
  end
  
  def html_graph(options={})
    dataset = Analyzer.hours_by_day(journal_entries_for_index)
    
    values  = dataset.collect(&:last)
    labels  = dataset.collect(&:first)
    
    max_value = values.max
    threshold = 6.0
    
    returning("") do |output|
      output << '<div class="graph-container">'
      
      values.each_with_index do |value, index|
        row = ""
        row << content_tag(:span, labels[index].strftime("%a %b %d"), :class => "index")
        
        if value > 0
          row << content_tag(:span, value, :class => "value")
          
          width = ((value / threshold) * 100.0).floor.to_s + "%"
          bar = content_tag(:div, " ", :style => "width:#{width}", :class => "bar")
          row << bar
        end
        
        output << content_tag(:div, row, :class => "row")
      end
      
      output << "<br style=\"clear:both\" /></div>"
    end
  end
  
  def chart_boogie
    chart =
      GChart.bar do |chart|
        chart.data = [[1,2,3,6], [5,5,5,5]]
        chart.colors = ["cc6600", "ffdd00", :green]
        chart.orientation = :horizontal
        chart.width = 200
        chart.height = 300
      end
    
    image_tag chart.to_url
  end
  
end