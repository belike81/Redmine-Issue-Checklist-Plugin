require File.dirname(__FILE__) + '/../test_helper'
require 'issue_checklists_controller'

class IssueChecklistsControllerTest < ActionController::TestCase
  fixtures :all, :issue_checklists
  # Replace this with your real tests.
  
  def setup
    RedmineIssueChecklist::TestCase.prepare
    Setting.default_language = 'en'
  end

  test "should not post new by deny user" do     
    @request.session[:user_id] = 5
    
    xhr :post, :new, :issue_id => 1, :new_checklist_item => "New checklist item"
    assert_response 401
  end      


  test "should post done" do     
    # log_user('admin', 'admin')   
    @request.session[:user_id] = 1
    
    xhr :post, :done, :is_done => true, :checklist_item_id => "1"
    assert_response :success
    assert_equal true, IssueChecklist.find(1).is_done
  end      

  test "should not post done by deny user" do     
    # log_user('admin', 'admin')   
    @request.session[:user_id] = 5
    
    xhr :post, :done, :is_done => true, :checklist_item_id => "1"
    assert_response 401
  end      
  
end
