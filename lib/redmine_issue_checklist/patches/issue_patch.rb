require_dependency 'issue'  

module RedmineIssueChecklist
  module Patches    
    
    module IssuePatch
      
      def self.included(base) # :nodoc: 
        base.class_eval do    
          unloadable # Send unloadable so it will not be unloaded in development
          
          has_many :checklist, :class_name => "IssueChecklist", :dependent => :destroy
        end  
      end  
        
    end
    
  end
end  

Dispatcher.to_prepare do  

  unless Issue.included_modules.include?(RedmineIssueChecklist::Patches::IssuePatch)
    Issue.send(:include, RedmineIssueChecklist::Patches::IssuePatch)
  end

end