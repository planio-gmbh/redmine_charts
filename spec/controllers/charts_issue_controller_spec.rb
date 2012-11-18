require File.dirname(__FILE__) + '/../spec_helper'
require File.dirname(__FILE__) + '/charts_controller_spec'

describe ChartsIssueController do

  before do
    @controller = ChartsIssueController.new
    User.current = nil
  end

  it "should range" do
    Setting.default_language = 'en'

    body = get_data :project_id => 15041, :project_ids => [15041, 15042]

    body['elements'][0]['values'].size.should == 3

    body['elements'][0]['values'][0]["label"].should == 'New'
    body['elements'][0]['values'][0]["value"].should be_close(1,1)
    body['elements'][0]['values'][0]["tip"].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "").should == "#{l(:charts_issue_hint, :label => 'New', :issues => 1, :percent => 20, :total_issues => 5)}"
      

    body['elements'][0]['values'][1]["label"].should == 'Assigned'
    body['elements'][0]['values'][1]["value"].should be_close(3,1)
    body['elements'][0]['values'][1]["tip"].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "").should == "#{l(:charts_issue_hint, :label => 'Assigned', :issues => 3, :percent => 60, :total_issues => 5)}"
      

    body['elements'][0]['values'][2]["label"].should == 'Resolved'
    body['elements'][0]['values'][2]["value"].should be_close(1,1)
    body['elements'][0]['values'][2]["tip"].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "").should == "#{l(:charts_issue_hint, :label => 'Resolved', :issues => 1, :percent => 20, :total_issues => 5)}"
      
  end

  it "should sub_tasks" do
    if RedmineCharts.has_sub_issues_functionality_active
      Setting.default_language = 'en'

      body = get_data :project_id => 15044, :project_ids => [15044]

      body['elements'][0]['values'].size.should == 1

      body['elements'][0]['values'][0]["label"].should == 'Resolved'
      body['elements'][0]['values'][0]["value"].should be_close(4,1)
      body['elements'][0]['values'][0]["tip"].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "").should == "#{l(:charts_issue_hint, :label => 'Resolved', :issues => 4, :percent => 100, :total_issues => 4)}"
      
    end
  end

end
