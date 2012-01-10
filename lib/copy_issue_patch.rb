module CopyIssuePatch
  def self.included(base)
    base.send(:include, InstanceMethods)

    base.class_eval do
      unloadable
      alias_method_chain :copy_from, :checklist
    end
  end

  module InstanceMethods
    def copy_from_with_checklist(arg)
      copy_from_without_checklist(arg)
      issue = Issue.visible.find(arg)
      self.checklist = issue.checklist
      puts "EXECUTED!"
      return self
    end
  end
end
