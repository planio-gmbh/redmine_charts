require File.dirname(__FILE__) + '/../spec_helper'

module RedmineCharts
describe GroupingUtils do
  before(:all) do
    @utils = RedmineCharts::PaginationUtils
  end

  it "should return_default_if_nothing_is_specified" do
    @utils.from_params({}).should == {:page => 1, :per_page => 10}
  end

  it "should return_page_and_perpage" do
    @utils.from_params({:page => "2"}).should == {:page => 2, :per_page => 10}
    @utils.from_params({:page => 4}).should == {:page => 4, :per_page => 10}
    @utils.from_params({:per_page => "11"}).should == {:page => 1, :per_page => 11}
    @utils.from_params({:per_page => 12}).should == {:page => 1, :per_page => 12}
    @utils.from_params({:page => "3", :per_page => 13}).should == {:page => 3, :per_page => 13}
  end

end
end
