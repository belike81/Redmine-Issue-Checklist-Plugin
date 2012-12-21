require 'redmine'
require 'dispatcher'

require 'redmine_issue_checklist/redmine_issue_checklist'
require 'copy_issue_patch'

require 'dispatcher'
Dispatcher.to_prepare do
  unless Issue.included_modules.include? CopyIssuePatch
    Issue.send(:include, CopyIssuePatch)
  end
end

Redmine::Plugin.register :redmine_issue_checklist do
  name 'Redmine Issue Checklist plugin'
  author 'Kirill Bezrukov'
  description 'This is a issue checklist plugin for Redmine'
  version '1.0.3'
  url 'http://redminecrm.com'
  author_url 'mailto:kirbez@redminecrm.com'
  
  settings :default => {
    :save_log => false,
    :issue_done_ratio => false
  }, :partial => 'settings/issue_checklist'
  
  Redmine::AccessControl.map do |map|
    map.project_module :issue_tracking do |map|
      map.permission :view_checklists, {}
      map.permission :done_checklists, {:issue_checklist => :done}
      map.permission :edit_checklists, {:issue_checklist => :delete, :issue_checklist => :done}
    end
  end
  
end
