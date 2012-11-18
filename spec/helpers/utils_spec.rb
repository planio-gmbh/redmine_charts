require File.dirname(__FILE__) + '/../spec_helper'
require 'rspec/rails'

module RedmineCharts
describe ConditionsUtils do

  it "should return_default_controller" do
    RedmineCharts::Utils.default_controller.should == "charts_burndown"
  end

  it "return controllers for permissions" do
    RedmineCharts::Utils.controllers_for_permissions.should == {:charts_burndown => :index, :charts_burndown2 => :index, :charts_ratio => :index, :charts_timeline => :index, :charts_deviation => :index, :charts_issue => :index}
  end

  it "should return routings" do
    result = []
    RedmineCharts::Utils.controllers_for_routing do |k,v|
      result << [k, v]
    end
    result.should == [["burndown", "charts_burndown"], ["burndown2", "charts_burndown2"], ["ratio", "charts_ratio"], ["timeline", "charts_timeline"], ["deviation", "charts_deviation"], ["issue", "charts_issue"]]
  end

  it "should return colors" do
    RedmineCharts::Utils.colors.should == [ '#80C31C', '#FF7900', '#DFC329', '#00477F', '#d01f3c', '#356aa0', '#C79810', '#4C88BE', '#5E4725', '#6363AC' ]
    RedmineCharts::Utils.color(2).should == '#DFC329'
  end

  it "can round" do
    RedmineCharts::Utils.round(0).should == 0.0
    RedmineCharts::Utils.round(3).should == 3.0
    RedmineCharts::Utils.round(3.1).should == 3.1
    RedmineCharts::Utils.round(3.11).should == 3.2
    RedmineCharts::Utils.round(3.191111).should == 3.2
  end

  it "can_get_percent" do
    RedmineCharts::Utils.percent(1,0).should == 0
    RedmineCharts::Utils.percent(3,10).should == 30
    RedmineCharts::Utils.percent(3,11).should == 27
  end

end
end
