require 'fileutils'

# Install JS file
js_path   = '/public/javascripts/lightbox.js'
js_target = File.dirname(__FILE__) + "/../../..#{js_path}"
FileUtils.cp File.dirname(__FILE__) + js_path, js_target unless File.exist?(js_target)

# Install CSS file
css_path   = '/public/stylesheets/lightbox.css'
css_target = File.dirname(__FILE__) + "/../../..#{css_path}"
FileUtils.cp File.dirname(__FILE__) + css_path, css_target unless File.exist?(css_target)

puts IO.read(File.join(File.dirname(__FILE__), 'README'))