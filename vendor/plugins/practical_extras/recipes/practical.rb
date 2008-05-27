class Capistrano::Configuration

  ##
  # Print an informative message with asterisks.

  def inform(message)
    puts "#{'*' * (message.length + 4)}"
    puts "* #{message} *"
    puts "#{'*' * (message.length + 4)}"
  end

  ##
  # Read a file and evaluate it as an ERB template.
  # Path is relative to this file's directory.

  def render_erb_template(filename)
    template = File.read(filename)
    result   = ERB.new(template).result(binding)
  end

  ##
  # Run a command and return the result as a string.
  #
  # TODO May not work properly on multiple servers.
  
  def run_and_return(cmd)
    output = []
    run cmd do |ch, st, data|
      output << data
    end
    return output.to_s
  end

end

namespace :web do
  desc "Restarts Apache"
  task :restart_apache, :role => :web do
    sudo "/usr/local/apache2/bin/apachectl restart"
  end
end

namespace :practical do
  
  desc "Shut down single Mongrel from old deploy script"
  task :legacy_stop do
    sudo "/usr/local/bin/ruby /usr/local/bin/mongrel_rails stop -P /home/practical/apps/#{application}/current/log/mongrel.#{mongrel_port}.pid"
  end
  
  desc "Generate spin script from variables"
  task :generate_spin_script, :roles => :app do
    template = File.read(File.dirname(__FILE__) + "/templates/spin.erb")
    result   = ERB.new(template).result(binding)
    put result, "#{release_path}/script/spin", :mode => 0755
  end
  after "deploy:update_code", "practical:generate_spin_script"
  
  desc "Create shared/config directory and default database.yml."
  task :create_shared_config do
    run "mkdir -p #{shared_path}/config"

    # Copy database.yml if it doesn't exist.
    result = run_and_return "ls #{shared_path}/config"
    unless result.match(/database\.yml/)
      contents = render_erb_template(File.dirname(__FILE__) + "/templates/database.yml")
      put contents, "#{shared_path}/config/database.yml"
      inform "Please edit database.yml in the shared directory."
    end
  end
  after "deploy:setup", "practical:create_shared_config"
  
  desc "Creates symlink to shared upload store"
  task :symlink_upload_store do
    run "ln -s #{shared_path}/uploads #{release_path}/public/uploads"
  end
  after "deploy:update_code", "practical:symlink_upload_store"
  
  desc "Copy config files"
  task :copy_config_files do
    run "cp #{shared_path}/config/* #{release_path}/config/"
  end
  after "deploy:update_code", "practical:copy_config_files"
  
  desc "Creates shared upload store"
  task :create_upload_store do
    run "mkdir -m 777 #{shared_path}/uploads"
  end
  after "deploy:setup", "practical:create_upload_store"
  
end