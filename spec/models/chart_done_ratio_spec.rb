require File.dirname(__FILE__) + '/../spec_helper'

describe ChartDoneRatio do

  before(:all) do
    @aggregation = ChartDoneRatio.get_aggregation_for_issue(:project_ids => [15041])
    Time.set_current_date = Time.mktime(2010,4,1)
    @timeline = ChartDoneRatio.get_timeline_for_issue({:project_ids => 15041}, {:range => :weeks, :limit => 11, :offset => 0})
  end

  it "should aggregation" do
    aggregation = ChartDoneRatio.get_aggregation_for_issue(:project_ids => [15041])
    aggregation[15041].should == 100
    aggregation[15043].should == 60
    aggregation[15044].should == 100
    aggregation[15045].should == 60
  end

  it "should timeline" do
    @timeline.should have(4).items
    @timeline[15041].size.should == 11
    @timeline[15043].size.should == 11
    @timeline[15044].size.should == 11
    @timeline[15045].size.should == 11
    @timeline[15041][0].should == 0
    @timeline[15041][1].should == 30
    @timeline[15041][2].should == 100
    @timeline[15041][9].should == 100
  end

end
