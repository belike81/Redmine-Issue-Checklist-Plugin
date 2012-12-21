#custom routes for this plugin
ActionController::Routing::Routes.draw do |map|
  map.connect "checklist/done/:checklist_item_id", :controller => "issue_checklists", :action => 'done'
  map.connect "checklist/delete/:checklist_item_id", :controller => "issue_checklists", :action => 'delete'
end