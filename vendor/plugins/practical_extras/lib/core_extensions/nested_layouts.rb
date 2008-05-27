module ActionView
  module Helpers
    module NestedLayoutsHelper
      def inside_layout(layout, &block)
        layout = layout.include?('/') ? layout : "layouts/#{layout}" 

        concat(@template.render_file(layout, true, '@content_for_layout' => capture(&block)), block.binding)
      end
    end
  end
end

ActionView::Base.class_eval do
  include ActionView::Helpers::NestedLayoutsHelper
end