# desc "Explaining what the task does"
# task :practical_extras do
#   # Task goes here
# end


namespace :practical do
  namespace :db do
    desc "Extract test fixtures from DB"
    task :extract_fixtures => :environment do
      sql = "SELECT * FROM %s"
      skip_tables = ["schema_info", "sessions"]
      ActiveRecord::Base.establish_connection
      tables = ENV['FIXTURES'] ? ENV['FIXTURES'].split(/,/) : ActiveRecord::Base.connection.tables - skip_tables
      tables.each do |table_name|
        i = "000"
        File.open("#{RAILS_ROOT}/db/#{table_name}.yml", 'w') do |file|
          data = ActiveRecord::Base.connection.select_all(sql % table_name)
          file.write data.inject({}) { |hash, record|
            hash["#{table_name}_#{i.succ!}"] = record
            hash
          }.to_yaml
        end
      end
    end
  end
end