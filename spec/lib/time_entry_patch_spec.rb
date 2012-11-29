require File.dirname(__FILE__) + '/../spec_helper'

module RedmineCharts
module TimeEntryPatch
describe "TimeEntryPatch" do

  before do
    Time.set_current_date = Time.mktime(2010,4,16)
    @issue = Issue.new(:project_id => 15041, :tracker_id => 1, :author_id => 1, :status_id => 1, :priority => IssuePriority.all.first, :subject => 'test_create', :description => 'IssueTest#test_create')

    @issue.save
  end

  it "should not work charts time_entry" do
    ChartTimeEntry.all(:conditions => {:issue_id => @issue.id}).size.should == 0
  end

  it "should add charts time entry" do
    time_entry = TimeEntry.new(:issue_id => @issue.id, :activity_id => 9, :hours => 2, :spent_on => Time.mktime(2010,3,11))
    time_entry.user_id = 1

    time_entry.save

    time_entries = ChartTimeEntry.all(:conditions => {:issue_id => @issue.id}, :order => "id asc")

    time_entries.size.should == 2

    time_entries[0].day.should == 2010070
    time_entries[0].week.should == 2010010
    time_entries[0].month.should == 2010003
    time_entries[0].issue_id.should == @issue.id
    time_entries[0].project_id.should == 15041
    time_entries[0].activity_id.should == 9
    time_entries[0].user_id.should == 1
    time_entries[0].logged_hours.should == 2
    time_entries[0].entries.should == 1

    time_entries[1].day.should == 0
    time_entries[1].week.should == 0
    time_entries[1].month.should == 0
    time_entries[1].issue_id.should == @issue.id
    time_entries[1].project_id.should == 15041
    time_entries[1].activity_id.should == 9
    time_entries[1].user_id.should == 1
    time_entries[1].logged_hours.should == 2
    time_entries[1].entries.should == 1

    time_entry = tmp_time_entry = TimeEntry.new(:issue_id => @issue.id, :activity_id => 9, :hours => 10, :spent_on => Time.mktime(2010,3,11))
    time_entry.user_id = 1

    time_entry.save

    time_entries = ChartTimeEntry.all(:conditions => {:issue_id => @issue.id}, :order => "id asc")

    time_entries.size.should == 2

    time_entries[0].day.should == 2010070
    time_entries[0].issue_id.should == @issue.id
    time_entries[0].activity_id.should == 9
    time_entries[0].user_id.should == 1
    time_entries[0].logged_hours.should == 12
    time_entries[0].entries.should == 2

    time_entries[1].day.should == 0
    time_entries[1].issue_id.should == @issue.id
    time_entries[1].activity_id.should == 9
    time_entries[1].user_id.should == 1
    time_entries[1].logged_hours.should == 12
    time_entries[1].entries.should == 2

    time_entry = TimeEntry.new(:issue_id => @issue.id, :activity_id => 9, :hours => 1, :spent_on => Time.mktime(2010,3,12))
    time_entry.user_id = 1

    time_entry.save

    time_entries = ChartTimeEntry.all(:conditions => {:issue_id => @issue.id}, :order => "id asc")

    time_entries.size.should == 3

    time_entries[0].day.should == 2010070
    time_entries[0].issue_id.should == @issue.id
    time_entries[0].activity_id.should == 9
    time_entries[0].user_id.should == 1
    time_entries[0].logged_hours.should == 12
    time_entries[0].entries.should == 2

    time_entries[1].day.should == 0
    time_entries[1].issue_id.should == @issue.id
    time_entries[1].activity_id.should == 9
    time_entries[1].user_id.should == 1
    time_entries[1].logged_hours.should == 13
    time_entries[1].entries.should == 3

    time_entries[2].day.should == 2010071
    time_entries[2].issue_id.should == @issue.id
    time_entries[2].activity_id.should == 9
    time_entries[2].user_id.should == 1
    time_entries[2].logged_hours.should == 1
    time_entries[2].entries.should == 1

    time_entry = TimeEntry.new(:issue_id => @issue.id, :activity_id => 10, :hours => 1, :spent_on => Time.mktime(2010,3,12))
    time_entry.user_id = 1

    time_entry.save

    time_entries = ChartTimeEntry.all(:conditions => {:issue_id => @issue.id}, :order => "id asc")

    time_entries.size.should == 5

    time_entries[0].day.should == 2010070
    time_entries[0].issue_id.should == @issue.id
    time_entries[0].activity_id.should == 9
    time_entries[0].user_id.should == 1
    time_entries[0].logged_hours.should == 12
    time_entries[0].entries.should == 2

    time_entries[1].day.should == 0
    time_entries[1].issue_id.should == @issue.id
    time_entries[1].activity_id.should == 9
    time_entries[1].user_id.should == 1
    time_entries[1].logged_hours.should == 13
    time_entries[1].entries.should == 3

    time_entries[2].day.should == 2010071
    time_entries[2].issue_id.should == @issue.id
    time_entries[2].activity_id.should == 9
    time_entries[2].user_id.should == 1
    time_entries[2].logged_hours.should == 1
    time_entries[2].entries.should == 1

    time_entries[3].day.should == 2010071
    time_entries[3].issue_id.should == @issue.id
    time_entries[3].activity_id.should == 10
    time_entries[3].user_id.should == 1
    time_entries[3].logged_hours.should == 1
    time_entries[3].entries.should == 1

    time_entries[4].day.should == 0
    time_entries[4].issue_id.should == @issue.id
    time_entries[4].activity_id.should == 10
    time_entries[4].user_id.should == 1
    time_entries[4].logged_hours.should == 1
    time_entries[4].entries.should == 1

    time_entry.hours = 2
    time_entry.save

    time_entries = ChartTimeEntry.all(:conditions => {:issue_id => @issue.id}, :order => "id asc")

    time_entries[3].day.should == 2010071
    time_entries[3].issue_id.should == @issue.id
    time_entries[3].activity_id.should == 10
    time_entries[3].user_id.should == 1
    time_entries[3].logged_hours.should == 2
    time_entries[3].entries.should == 1

    time_entries[4].day.should == 0
    time_entries[4].issue_id.should == @issue.id
    time_entries[4].activity_id.should == 10
    time_entries[4].user_id.should == 1
    time_entries[4].logged_hours.should == 2
    time_entries[4].entries.should == 1

    tmp_time_entry.hours = 20
    tmp_time_entry.save

    time_entries = ChartTimeEntry.all(:conditions => {:issue_id => @issue.id}, :order => "id asc")

    time_entries[0].day.should == 2010070
    time_entries[0].issue_id.should == @issue.id
    time_entries[0].activity_id.should == 9
    time_entries[0].user_id.should == 1
    time_entries[0].logged_hours.should == 22
    time_entries[0].entries.should == 2

    time_entries[1].day.should == 0
    time_entries[1].issue_id.should == @issue.id
    time_entries[1].activity_id.should == 9
    time_entries[1].user_id.should == 1
    time_entries[1].logged_hours.should == 23
    time_entries[1].entries.should == 3

    @issue.destroy

    ChartTimeEntry.all(:conditions => {:issue_id => @issue.id}).size.should == 0
  end

end
end
end
