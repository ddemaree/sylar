require File.dirname(__FILE__) + '/../test_helper'

class TaskTest < ActiveSupport::TestCase
  
  def test_automagical_named_scope_definitions
    assert Task.respond_to?(:open)
    
    open_tasks = Task.open
    assert_equal 2, open_tasks.length
    assert_equal tasks(:open_task), open_tasks.first
  end
  
  def test_auto_assignment_of_start_time_on_wake
    sleeping_task = tasks(:sleeping_task)
    assert (Time.now - 2.hours), sleeping_task.started_at
    
    assert sleeping_task.wake!
    assert Time.now, sleeping_task.started_at
  end
  
  def test_auto_assignment_of_start_time_on_create
    new_task = Task.new(:description => "This is a brand new task", :trackable => trackables(:practical_trackable), :user => users(:quentin))
    
    assert new_task.save!
    assert Time.now, new_task.started_at
  end
  
  def test_auto_sleep_all_open_tasks_on_open
    assert_equal 2, Task.open.count
    assert_equal 1, Task.sleeping.count
    assert_equal tasks(:open_task), Task.open.first
    
    sleeping_task = tasks(:sleeping_task)
    assert sleeping_task.wake!
    
    assert_equal 2, Task.open.count
    assert_equal 1, Task.sleeping.count
    assert_equal tasks(:sleeping_task), Task.open.first
  end
  
  def test_auto_sleep_all_open_tasks_on_create
    quentin_user = users(:quentin)
    
    assert_equal 1, quentin_user.tasks.open.count
    assert_equal tasks(:open_task), quentin_user.tasks.open.first
  
    new_task = Task.new(:description => "This is a brand new task", :trackable => trackables(:practical_trackable), :user => quentin_user)
    
    assert new_task.save!
    assert_equal 2, Task.open.count
    assert_equal 1, quentin_user.tasks.open.count
    assert_equal new_task, quentin_user.tasks.open.first
  end
  
  def test_calculation_of_hours_since_start_time
    open_task = tasks(:open_task)
    assert_equal 2.5, open_task.hours
  end
  
  def test_creation_of_time_record_on_sleep
    open_task = tasks(:open_task)
    assert_equal 0, open_task.journal_entries.count
    
    assert open_task.sleep!
    assert_equal 1, open_task.journal_entries.count
    assert_equal 2.5, open_task.total_hours
    
    new_journal_entry = open_task.journal_entries.first
    assert_equal 2.5, new_journal_entry.hours
  end
  
end
