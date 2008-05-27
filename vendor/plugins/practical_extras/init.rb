# Include hook code here
#require 'practical_extras'
require 'helpers/practical_helper'
require 'helpers/practical_form_extensions'

require 'practical_password_generator'
require 'core_extensions/active_record'
require 'core_extensions/time'
require 'core_extensions/nested_layouts'
require 'core_extensions/record_identifier'

ActiveRecord::Base.extend Practical::Extensions::ActiveRecordSearch
ActiveRecord::Base.send :include, Practical::Extensions::ActiveRecord
ActionView::Base.send :include, PracticalHelper