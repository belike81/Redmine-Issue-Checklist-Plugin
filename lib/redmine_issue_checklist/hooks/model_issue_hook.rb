# This file is a part of redmine_tags
# redMine plugin, that adds tagging support.
#
# Copyright (c) 2010 Eric Davis
# Copyright (c) 2010 Aleksey V Zapparov AKA ixti
#
# redmine_tags is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# redmine_tags is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with redmine_tags.  If not, see <http://www.gnu.org/licenses/>.

module RedmineIssueChecklist
  module Hooks
    class ModelIssueHook < Redmine::Hook::ViewListener
      
      def controller_issues_edit_before_save(context={})
        save_checklist_to_issue(context, true)
      end

      def controller_issues_new_after_save(context={})
        save_checklist_to_issue(context, false)
        context[:issue].save
      end
      
      def save_checklist_to_issue(context, create_journal)
        params = context[:params]
        params[:check_list_items] ||= []
        if params && params[:issue]
          
          old_checklist = context[:issue].checklist.collect(&:info).join(', ')

          checklist = params[:check_list_items].uniq.collect{|cli| IssueChecklist.new(:is_done => cli[:is_done], 
                                                                                 :subject => cli[:subject])}
          context[:issue].checklist.destroy_all 
          context[:issue].checklist << checklist 

          new_checklist = context[:issue].checklist.collect(&:info).join(', ')
      
          if create_journal and not ((new_checklist == old_checklist) || context[:issue].current_journal.blank?)
            context[:issue].current_journal.details << JournalDetail.new(:property => 'attr',
                                                                         :prop_key => 'checklist',
                                                                         :old_value => old_checklist,
                                                                         :value => new_checklist)
          end
        end
      end

    end
  end
end
