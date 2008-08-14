RAILS_GEM_VERSION = '2.1' unless defined? RAILS_GEM_VERSION

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|
  config.time_zone = 'UTC'
  config.action_controller.session = {
    :session_key => '_sylar_session',
    :secret      => '7718624ea521eee16b9e9216dc610ef9c16c1798c089cbb6cc7ccc2a22bb017515e5eb7922a39fdc617166ee8a20cd0ac64b40d4985feafba19eb1def2936b70'
  }
end

require 'core_extensions'