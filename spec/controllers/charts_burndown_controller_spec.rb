require File.dirname(__FILE__) + '/../spec_helper'

describe ChartsBurndownController do
  fixtures :all

  before do
    Time.set_current_date = Time.mktime(2010,3,12)
    User.current = nil
  end

  it "should charts_burndown#index" do
    get :index, :project_id => 15041, :project_ids => [15041, 15042], :limit => '4', :range => 'days', :offset => '1'
    response.should be_success
  end

end
