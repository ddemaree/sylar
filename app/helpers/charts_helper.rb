require 'gchart'

module ChartsHelper
  
  def color_dot(client)
    image_tag("colordot_48.png", :style => "background-color:##{client_color(client)}", :class => "colordot")
  end
  
  def client_color(client)
    colors_for_clients[client]
  end
  
  def colors_for_clients
    colors = %w(c30 c90 cc0 6c0 06c 96c 999)
    clients = journal_entries_for_index.collect(&:client).uniq
    client_colors = {}
    
    clients.first(6).each_index do |x|
      client_colors[clients[x]] = colors[x]
    end
    
    client_colors
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
  
  def clients_pie_chart(dataset,options={})
    options.reverse_merge!({
      :key => :hours,
      :colors => ["666"],
      :html => {:class => "pie_chart"}
    })
    
    clients = dataset.collect { |r| r.first }
    values = dataset.collect { |r| r.last[options[:key]] }
    labels = clients.collect(&:to_s)
    
    options[:colors] =
      clients.collect { |c| colors_for_clients[c] }
    
    g =
      GChart.pie do |c|
        c.data   = values
        c.colors = options[:colors]
        c.height = 200
        c.width = 200
        c.entire_background = "fff"
        #c.legend = labels
      end
      
    image_tag g.to_url, options[:html]
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