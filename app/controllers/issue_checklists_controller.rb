class IssueChecklistsController < ApplicationController
  unloadable

  before_filter :find_checklist_item

  def done
    (render_403; return false) unless User.current.allowed_to?(:edit_issues, @checklist_item.issue.project)

    old_checklist_item = @checklist_item.clone
    @checklist_item.is_done = !@checklist_item.is_done

    @checklist_item.save
    if old_checklist_item.info != @checklist_item.info
      journal = Journal.new(:journalized => @checklist_item.issue, :user => User.current)
      journal.details << JournalDetail.new(:property => 'attr',
                                                    :prop_key => 'checklist',
                                                    :old_value => old_checklist_item.info,
                                                    :value => @checklist_item.info)
      journal.save
    end
    respond_to do |format|
      format.js do
        render :update do |page|
            # page["checklist_item_#{@checklist_item.id}"].visual_effect :appear
            page.send :record, "Element.toggleClassName('checklist_item_#{@checklist_item.id}', 'is-done-checklist-item')"
        end
      end
      format.html {redirect_to :back }
    end

  end

  def delete
    (render_403; return false) unless User.current.allowed_to?(:edit_issues, @checklist_item.issue.project)

    @checklist_item.delete
    respond_to do |format|
      format.js do
        render :update do |page|
            page["checklist_item_#{@checklist_item.id}"].visual_effect :fade
        end
      end
      format.html {redirect_to :back }
    end

  end

  private

  def find_checklist_item
    @checklist_item = IssueChecklist.find(params[:checklist_item_id])
    @project = @checklist_item.issue.project
  end


end
