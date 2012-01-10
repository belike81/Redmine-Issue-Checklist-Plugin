require 'redmine'
require 'dispatcher'


require 'redmine_issue_checklist/hooks/views_issues_hook'
require 'redmine_issue_checklist/hooks/model_issue_hook'

require_dependency 'issue'
require_dependency 'copy_issue_patch'
require 'redmine_issue_checklist/patches/issue_patch'

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
  version '1.0.0'
  url 'http://redminecrm.com'
  author_url 'mailto:kirbez@redminecrm.com'

end
