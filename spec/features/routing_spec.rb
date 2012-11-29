require File.dirname(__FILE__) + '/../spec_helper'

describe "Routing", :type => :controller do

  before(:all) do
    @request = ActionController::TestRequest.new
    @request.session[:user_id] = 1
  end

  it "should routes to burndown" do
    @controller = ChartsBurndownController.new
    get("/projects/Project1/charts/burndown/index").should route_to("charts_burndown#index")
  end

  it "should routes to burndown2" do
    @controller = ChartsBurndown2Controller.new
    get("/projects/Project1/charts/burndown2/index").should route_to("charts_burndown2#index")
  end

  it "should routes to ratio" do
    @controller = ChartsRatioController.new
    get("/projects/Project1/charts/ratio/index").should route_to("charts_ratio#index")
  end

  it "should routes to timeline" do
    @controller = ChartsTimelineController.new
    get("/projects/Project1/charts/timeline/index").should route_to("charts_timeline#index")
  end

  it "should routes to deviation" do
    @controller = ChartsDeviationController.new
    get("/projects/Project1/charts/deviation/index").should route_to("charts_deviation#index")
  end

  it "should routes to Issue" do
    @controller = ChartsIssueController.new
    get("/projects/Project1/charts/issue/index").should route_to("charts_issue#index")
  end

end
