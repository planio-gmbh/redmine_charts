require File.dirname(__FILE__) + '/../spec_helper'
#require File.dirname(__FILE__) + '/charts_controller_spec'
#require 'charts_burndown_controller'

describe "ChartsBurndownController" do

  before do
    Time.set_current_date = Time.mktime(2010,3,12)
    @controller = ChartsBurndownController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    User.current = nil
  end

  it "test_get_data" do
    Setting.default_language = 'en'

    get :index, :project_id => 15041, :project_ids => [15041, 15042], :limit => '4', :range => 'days', :offset => '1'
    response.should be_success

    body = get_data :project_id => 15041, :project_ids => [15041, 15042], :limit => '4', :range => 'days', :offset => '1'

    l(:charts_burndown_y).should equal(body['y_legend']['text'])
    l(:charts_burndown_x).should equal(body['x_legend']['text'])
    body['y_axis']['max'].should be_close(81, 1)
    body['y_axis']['min'].should == 0
    body['x_axis']['max'].should be_close(4, 1)
    body['x_axis']['min'].should == 0
    body['x_axis']['labels']['labels'].size.should == 4
    body['x_axis']['labels']['labels'][0].should equal('08 Mar 10')
    body['x_axis']['labels']['labels'][1].should == '09 Mar 10'
    body['x_axis']['labels']['labels'][2].should == '10 Mar 10'
    body['x_axis']['labels']['labels'][3].should == '11 Mar 10'

    body['elements'].size.should == 4
    body['elements'][0]['values'].size.should == 4
    body['elements'][0]['text'].should == l(:charts_burndown_group_estimated)
    body['elements'][1]['values'].size.should == 4
    body['elements'][1]['text'].should == l(:charts_burndown_group_logged)
    body['elements'][2]['values'].size.should == 4
    body['elements'][2]['text'].should == l(:charts_burndown_group_remaining)
    body['elements'][3]['values'].size.should == 4
    body['elements'][3]['text'].should == l(:charts_burndown_group_predicted)

    body['elements'][0]['values'][0]['value'].should be_close(23,0.1)
    body['elements'][0]['values'][0]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "").should == "#{l(:charts_burndown_hint_estimated, :estimated_hours => 23.0)}<br>#{'08 Mar 10'}"
    body['elements'][0]['values'][1]['value'].should be_close(35,0.1)
    body['elements'][0]['values'][1]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "").should == "#{l(:charts_burndown_hint_estimated, :estimated_hours => 35.0)}<br>#{'09 Mar 10'}"
    body['elements'][0]['values'][2]['value'].should be_close(35,0.1)
    body['elements'][0]['values'][2]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "").should == "#{l(:charts_burndown_hint_estimated, :estimated_hours => 35.0)}<br>#{'10 Mar 10'}"
    body['elements'][0]['values'][3]['value'].should be_close(35,0.1)
    body['elements'][0]['values'][3]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "").should == "#{l(:charts_burndown_hint_estimated, :estimated_hours => 35.0)}<br>#{'11 Mar 10'}"

    body['elements'][1]['values'][0]['value'].should be_close(29.35,0.1)
    body['elements'][1]['values'][0]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "").should == "#{l(:charts_burndown_hint_logged, :logged_hours => 29.4)}<br>#{'08 Mar 10'}"
    body['elements'][1]['values'][1]['value'].should be_close(35.95,0.1)
    body['elements'][1]['values'][1]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "").should == "#{l(:charts_burndown_hint_logged, :logged_hours => 36.0)}<br>#{'09 Mar 10'}"
    body['elements'][1]['values'][2]['value'].should be_close(43.35,0.1)
    body['elements'][1]['values'][2]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "").should == "#{l(:charts_burndown_hint_logged, :logged_hours => 43.4)}<br>#{'10 Mar 10'}"
    body['elements'][1]['values'][3]['value'].should be_close(43.35,0.1)
    body['elements'][1]['values'][3]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "").should == "#{l(:charts_burndown_hint_logged, :logged_hours => 43.4)}<br>#{'11 Mar 10'}"

    body['elements'][2]['values'][0]['value'].should be_close(5.1,0.1)
    body['elements'][2]['values'][0]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "").should == "#{l(:charts_burndown_hint_remaining, :remaining_hours => 5.1, :work_done => 90)}<br>#{'08 Mar 10'}"
    body['elements'][2]['values'][1]['value'].should be_close(31.5,0.1)
    body['elements'][2]['values'][1]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "").should == "#{l(:charts_burndown_hint_remaining, :remaining_hours => 31.5, :work_done => 76)}<br>#{'09 Mar 10'}"
    body['elements'][2]['values'][2]['value'].should be_close(11.0,0.1)
    body['elements'][2]['values'][2]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "").should == "#{l(:charts_burndown_hint_remaining, :remaining_hours => 11.0, :work_done => 84)}<br>#{'10 Mar 10'}"
    body['elements'][2]['values'][3]['value'].should be_close(11.0,0.1)
    body['elements'][2]['values'][3]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "").should == "#{l(:charts_burndown_hint_remaining, :remaining_hours => 11.0, :work_done => 84)}<br>#{'11 Mar 10'}"

    body['elements'][3]['values'][0]['value'].should be_close(34.4,0.1)
    body['elements'][3]['values'][0]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "").should == "#{l(:charts_burndown_hint_predicted_over_estimation, :predicted_hours => 34.5, :hours_over_estimation => 11.5)}<br>#{'08 Mar 10'}"
    body['elements'][3]['values'][1]['value'].should be_close(67.4,0.1)
    body['elements'][3]['values'][1]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "").should == "#{l(:charts_burndown_hint_predicted_over_estimation, :predicted_hours => 67.5, :hours_over_estimation => 32.5)}<br>#{'09 Mar 10'}"
    body['elements'][3]['values'][2]['value'].should be_close(54.4,0.1)
    body['elements'][3]['values'][2]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "").should == "#{l(:charts_burndown_hint_predicted_over_estimation, :predicted_hours => 54.4, :hours_over_estimation => 19.4)}<br>#{'10 Mar 10'}"
    body['elements'][3]['values'][3]['value'].should be_close(54.4,0.1)
    body['elements'][3]['values'][3]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "").should == "#{l(:charts_burndown_hint_predicted_over_estimation, :predicted_hours => 54.4, :hours_over_estimation => 19.4)}<br>#{'11 Mar 10'}"

  end

  it "should sub_tasks" do
    if RedmineCharts.has_sub_issues_functionality_active
      Setting.default_language = 'en'

      body = get_data :project_id => 15044, :project_ids => [15044], :limit => '1', :range => 'weeks', :offset => '0'

      body['elements'][0]['values'].size.should == 1

      body['elements'][0]['values'][0]['value'].should be_close(12,0.1)
      body['elements'][0]['values'][0]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "").should == "#{l(:charts_burndown_hint_estimated, :estimated_hours => 12.0)}<br>#{'8 - 14 Mar 10'}"

      body['elements'][1]['values'][0]['value'].should be_close(13.2,0.1)
      body['elements'][1]['values'][0]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "").should == "#{l(:charts_burndown_hint_logged, :logged_hours => 13.2)}<br>#{'8 - 14 Mar 10'}"

      body['elements'][2]['values'][0]['value'].should be_close(12,0.1)
      body['elements'][2]['values'][0]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "").should == "#{l(:charts_burndown_hint_remaining, :remaining_hours => 12.0, :work_done => 0)}<br>#{'8 - 14 Mar 10'}"

      body['elements'][3]['values'][0]['value'].should be_close(25.2,0.1)
      body['elements'][3]['values'][0]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "").should == "#{l(:charts_burndown_hint_predicted_over_estimation, :predicted_hours => 25.2, :hours_over_estimation => 13.2)}<br>#{'8 - 14 Mar 10'}"
    end
  end

end
