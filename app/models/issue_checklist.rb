class IssueChecklist < ActiveRecord::Base
  unloadable
  belongs_to :issue
  belongs_to :author, :class_name => "User", :foreign_key => "author_id"
  acts_as_list
  
  validates_presence_of :subject
  
  def editable_by?(usr=User.current)
    usr && (usr.allowed_to?(:edit_checklists, project) || (self.author == usr && usr.allowed_to?(:edit_own_checklists, project)))
  end
  
  def project
    self.issue.project if self.issue 
  end  
  
  def info
    "[#{self.is_done ? 'x' : ' ' }] #{self.subject.strip}"
  end
  
end
