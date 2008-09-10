require "fileutils"

FileUtils.cd(File.dirname(__FILE__)) do
  Dir[*%w( public/javascripts/* public/stylesheets/* )].each do |file|
    FileUtils.cd(File.join("../../..", File.dirname(file))) do
      FileUtils.ln_s(File.join("../../vendor/plugins/calendar_date_select", file), File.basename(file), :force => true)
    end
  end
end
