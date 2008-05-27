# Include hook code here
require 'lightbox_helper'
ActionView::Base.send :include, Practical::LightboxHelper
ActionView::Helpers::AssetTagHelper.register_javascript_include_default('lightbox')