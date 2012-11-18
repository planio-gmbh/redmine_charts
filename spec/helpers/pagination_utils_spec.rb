require File.dirname(__FILE__) + '/../spec_helper'

describe "GroupingUtils" do

  it "should return_default_if_nothing_is_specified" do
    RedmineCharts::PaginationUtils.from_params({}).should == {:page => 1, :per_page => 10}
  end

  it "should return_page_and_perpage" do
    RedmineCharts::PaginationUtils.from_params({:page => "2"}).should == {:page => 2, :per_page => 10}
    RedmineCharts::PaginationUtils.from_params({:page => 4}).should == {:page => 4, :per_page => 10}
    RedmineCharts::PaginationUtils.from_params({:per_page => "11"}).should == {:page => 1, :per_page => 11}
    RedmineCharts::PaginationUtils.from_params({:per_page => 12}).should == {:page => 1, :per_page => 12}
    RedmineCharts::PaginationUtils.from_params({:page => "3", :per_page => 13}).should == {:page => 3, :per_page => 13}
  end

end
