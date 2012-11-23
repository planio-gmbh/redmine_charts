require File.dirname(__FILE__) + '/../spec_helper'

module RedmineCharts
module IssuePatch
  describe "IssuePatch" do

    before do
      Time.set_current_date = Time.mktime(2010,3,11)

      @issue = Issue.new(:project_id => 15041, :tracker_id => 1, :author_id => 1, :status_id => 1, :priority => IssuePriority.all.first, :subject => 'test_create', :description => 'IssueTest#test_create')
      @issue.save
    end

    it "should add issue_status" do

      issue_status = ChartIssueStatus.all(:conditions => {:issue_id => @issue.id})

      issue_status.size.should == 1

      issue_status[0].day.should == 2010070
      issue_status[0].week.should == 2010010
      issue_status[0].month.should == 2010003
      issue_status[0].issue_id.should == @issue.id
      issue_status[0].project_id.should == 15041
      issue_status[0].status_id.should == 1
    end

    it "should change issue_status if status is assigned" do
      @issue.status_id = 2
      @issue.save

      issue_status = ChartIssueStatus.all(:conditions => {:issue_id => @issue.id})

      issue_status.size.should == 1
      issue_status[0].status_id.should == 2
    end

    it "should add new issue_status if status is resolved" do
      @issue.status_id = 2
      @issue.save
      Time.set_current_date = Time.mktime(2010,3,12)

      @issue.status_id = 3
      @issue.save

      issue_status = ChartIssueStatus.all(:conditions => {:issue_id => @issue.id})

      issue_status.size.should == 2

      issue_status[0].status_id.should == 2
      issue_status[1].status_id.should == 3

      @issue.destroy
    end

    it "should set done_ratio if status is finished" do
      @issue.status_id = 5
      @issue.save

      done_ratio = ChartDoneRatio.all(:conditions => {:issue_id => @issue.id})

      done_ratio.size.should == 2

      done_ratio[0].done_ratio.should == 100
      done_ratio[1].done_ratio.should == 100

      @issue.destroy
    end

    it "should add done_ratio" do
      ChartDoneRatio.all(:conditions => {:issue_id => @issue.id}).size.should == 0

      @issue.done_ratio = 10
      @issue.save

      done_ratio = ChartDoneRatio.all(:conditions => {:issue_id => @issue.id}, :order => "id asc")

      done_ratio.size.should == 2

      done_ratio[0].day.should == 0
      done_ratio[0].week.should == 0
      done_ratio[0].month.should == 0
      done_ratio[0].issue_id.should == @issue.id
      done_ratio[0].project_id.should == 15041
      done_ratio[0].done_ratio.should == 10

      done_ratio[1].day.should == 2010070
      done_ratio[1].week.should == 2010010
      done_ratio[1].month.should == 2010003
      done_ratio[1].issue_id.should == @issue.id
      done_ratio[1].project_id.should == 15041
      done_ratio[1].done_ratio.should == 10
    end

    it "should get 2 done_ratio" do
      @issue.done_ratio = 10
      @issue.save

      @issue.done_ratio = 20
      @issue.save

      done_ratio = ChartDoneRatio.all(:conditions => {:issue_id => @issue.id}, :order => "id asc")

      done_ratio.size.should == 2
      done_ratio[0].done_ratio.should == 20
      done_ratio[1].done_ratio.should == 20
    end

    it "should get 3 done_ratio" do
      @issue.done_ratio = 10
      @issue.save

      @issue.done_ratio = 20
      @issue.save

      Time.set_current_date = Time.mktime(2010,3,12)
      @issue.done_ratio = 30
      @issue.save

      done_ratio = ChartDoneRatio.all(:conditions => {:issue_id => @issue.id}, :order => "id asc")

      done_ratio.size.should == 3
      done_ratio[0].done_ratio.should == 30
      done_ratio[1].done_ratio.should == 20
      done_ratio[2].done_ratio.should == 30
    end

    it "should delete done_ratio if issues deleted" do
      @issue.done_ratio = 10
      @issue.save

      @issue.destroy

      ChartDoneRatio.all(:conditions => {:issue_id => @issue.id}).size.should == 0
    end

    it "should create done_ratio with done_ratio" do
      @issue = Issue.new(:project_id => 15041, :tracker_id => 1, :author_id => 1, :status_id => 1, :priority => IssuePriority.all.first, :subject => 'test_create', :description => 'IssueTest#test_create', :done_ratio => 20)
      @issue.save


      ChartDoneRatio.all(:conditions => {:issue_id => @issue.id}).size.should == 2

      @issue.destroy

      ChartDoneRatio.all(:conditions => {:issue_id => @issue.id}).size.should == 0
    end

  end
end
end
