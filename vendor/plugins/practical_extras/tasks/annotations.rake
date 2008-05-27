require File.dirname(__FILE__) + "/../lib/practical_annotations"

namespace :practical do
  
  desc "Enumerate all annotations"
  task :notes do
    PracticalAnnotations.enumerate "WTF|OPTIMIZE|FIXME|TODO", :tag => true
  end

  namespace :notes do

    desc "Enumerate all wtf annotations"
    task :wtf do
      PracticalAnnotations.enumerate "WTF"
    end
  end
  
end