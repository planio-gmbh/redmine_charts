require File.dirname(__FILE__) + '/../spec_helper'
require File.dirname(__FILE__) + '/charts_controller_spec'

class ChartsRatioController

  def rescue_action(e)
    raise e
  end

  def authorize
    true
  end

  def saved_conditions
    @saved_conditions
  end

  def saved_condition
    @saved_condition
  end

end

describe ChartsRatioController do

  include Redmine::I18n

  before do
    @controller = ChartsRatioController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    User.current = nil
  end

  it "should return_saved_conditions" do
    ChartSavedCondition.destroy_all

    c = ChartSavedCondition.new(:name => "Test", :chart => "ratio", :project_id => 15041)
    c.conditions = {:a => "b"}
    c.save

    get :index, {:project_id => 15041}
    response.should be_success

    @controller.saved_conditions.size.should == 1
  end

  it "should return_saved_conditions_for_all_projects" do
    ChartSavedCondition.destroy_all

    c = ChartSavedCondition.new(:name => "Test", :chart => "ratio", :project_id => nil)
    c.conditions = {:a => "b"}
    c.save

    get :index, {:project_id => 15041}
    response.should be_success

    @controller.saved_conditions.size.should == 1
  end

  it "should not_return_saved_conditions_for_other_project" do
    ChartSavedCondition.destroy_all

    c = ChartSavedCondition.new(:name => "Test", :chart => "ratio", :project_id => 15042)
    c.conditions = {:a => "b"}
    c.save

    get :index, {:project_id => 15041}
    response.should be_success

    @controller.saved_conditions.size.should == 0
  end

  it "should destroy_saved_condition" do
    ChartSavedCondition.destroy_all

    c = ChartSavedCondition.new(:name => "Test", :chart => "ratio", :project_id => 15041)
    c.conditions = {:a => "b"}
    c.save

    ChartSavedCondition.all.size.should == 1

    get :destroy_saved_condition, {:project_id => 15041, :id => c.id }
    response.should be_success

    ChartSavedCondition.all.size.should == 0

    flash[:notice].should == l(:charts_saved_condition_flash_deleted)
  end

  it "should return_error_when_try_destroy_not_existed_saved_conditions" do
    ChartSavedCondition.destroy_all

    get :destroy_saved_condition, {:project_id => 15041, :id => 1 }
    response.should be_success

    flash[:error].should == l(:charts_saved_condition_flash_not_found)
  end

  it "should create_saved_conditions" do
    ChartSavedCondition.destroy_all

    get :index, {:project_id => 15041, :chart_form_action => 'saved_condition_create', :saved_condition_create_name => "Test", :saved_condition_create_project_id => 15041, :project_ids => [15041], :grouping => :activity_id, :priority_ids => [5, 6] }
    response.should be_success

    condition = ChartSavedCondition.first

    assert_not_nil condition
    condition.name.should == "Test"
    condition.chart.should == "ratio"
    condition.project_id.should == 15041
    conditions = condition.conditions.split("&")
    conditions.size.should == 4
    conditions.should include("grouping=activity_id")
    conditions.should include("priority_ids[]=5")
    conditions.should include("priority_ids[]=6")
    conditions.should include("project_ids[]=15041")
    flash[:notice].should == l(:charts_saved_condition_flash_created)
  end

  it "should return_error_for_blank_name" do
    ChartSavedCondition.destroy_all

    get :index, {:project_id => 15041, :chart_form_action => 'saved_condition_create', :saved_condition_create_name => "", :saved_condition_create_project_id => 15041 }
    response.should be_success

    flash[:error].should == l(:charts_saved_condition_flash_name_cannot_be_blank)
  end

  it "should return_error_for_duplicated_name" do
    ChartSavedCondition.destroy_all

    c = ChartSavedCondition.new(:name => "Test", :chart => "ratio", :project_id => 15041)
    c.conditions = {:a => "b"}
    c.save

    get :index, {:project_id => 15041, :chart_form_action => 'saved_condition_create', :saved_condition_create_name => "Test", :saved_condition_create_project_id => 15041 }
    response.should be_success

    flash[:error].should == l(:charts_saved_condition_flash_name_exists)
  end

  it "should update_saved_conditions" do
    ChartSavedCondition.destroy_all

    c = ChartSavedCondition.new(:name => "Old test", :chart => "old_ratio", :project_id => 15041)
    c.conditions = {:a => "b"}
    c.save

    get :index, {:project_id => 15041, :chart_form_action => 'saved_condition_update', :saved_condition_update_name => "Test", :saved_condition_update_project_id => nil, :saved_condition_id => c.id, :project_ids => [15041], :grouping => :activity_id, :priority_ids => [5, 6] }
    response.should be_success

    condition = ChartSavedCondition.first

    assert_not_nil condition
    condition.name.should == "Test"
    condition.chart.should == "ratio"
    assert_nil condition.project_id

    conditions = condition.conditions.split("&")
    conditions.size.should == 4
    conditions.should include("grouping=activity_id")
    conditions.should include("priority_ids[]=5")
    conditions.should include("priority_ids[]=6")
    conditions.should include("project_ids[]=15041")

    flash[:notice].should == l(:charts_saved_condition_flash_updated)
  end

end
