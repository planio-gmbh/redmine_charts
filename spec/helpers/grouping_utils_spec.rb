require File.dirname(__FILE__) + '/../spec_helper'

module RedmineCharts
describe GroupingUtils do

  it "should return_grouping_types" do
    RedmineCharts::GroupingUtils.types.should == [ :user_id, :issue_id, :activity_id, :category_id, :tracker_id, :fixed_version_id, :priority_id, :author_id, :status_id, :project_id, :assigned_to_id ]
  end

  it "should return_all_for_nil_or_none_grouping" do
    RedmineCharts::GroupingUtils.to_string(nil, nil).should == "all"
    RedmineCharts::GroupingUtils.to_string(4, :none).should == "all"
    RedmineCharts::GroupingUtils.to_string(nil, nil, "default").should == "all"
    RedmineCharts::GroupingUtils.to_string(4, :none, "default").should == "all"
  end

  it "should return_none_for_not_existed_grouping" do
    RedmineCharts::GroupingUtils.to_string(3, :other).should == "none"
  end

  it "should return_default_if_provided" do
    RedmineCharts::GroupingUtils.to_string(3, :other, "default").should == "default"
  end

  it "should return_string_representation_of_users_grouping" do
    RedmineCharts::GroupingUtils.to_string(2, :user_id).should == "John Smith"
    RedmineCharts::GroupingUtils.to_string(0, :user_id).should == "none"
    RedmineCharts::GroupingUtils.to_string(666, :user_id, "Ozzy").should == "Ozzy"
  end

  it "should return_string_representation_of_issues_grouping" do
    RedmineCharts::GroupingUtils.to_string(15042, :issue_id).should == "#15042 Issue2"
  end

  it "should return_string_representation_of_activities_grouping" do
    RedmineCharts::GroupingUtils.to_string(9, :activity_id).should == "Design"
  end

  it "should return_string_representation_of_categories_grouping" do
    RedmineCharts::GroupingUtils.to_string(15042, :category_id).should == "Category2"
  end

  it "should return_string_representation_of_trackers_grouping" do
    RedmineCharts::GroupingUtils.to_string(1, :tracker_id).should == "Bug"
  end

  it "should return_string_representation_of_versions_grouping" do
    RedmineCharts::GroupingUtils.to_string(15042, :fixed_version_id).should == "2.0"
  end

  it "should return_string_representation_of_priorities_grouping" do
    RedmineCharts::GroupingUtils.to_string(5, :priority_id).should == "Normal"
  end

  it "should return_string_representation_of_authors_grouping" do
    RedmineCharts::GroupingUtils.to_string(3, :author_id).should == "Dave Lopper"
  end

  it "should return_string_representation_of_owners_grouping" do
    RedmineCharts::GroupingUtils.to_string(3, :assigned_to_id).should == "Dave Lopper"
  end

  it "should return_string_representation_of_statuses_grouping" do
    RedmineCharts::GroupingUtils.to_string(2, :status_id).should == "Assigned"
  end

  it "should return_string_representation_of_projects_grouping" do
    RedmineCharts::GroupingUtils.to_string(15042, :project_id).should == "#15042 Project2"
  end

  it "should return_nil_when_param_does_not_include_grouping" do
    types = RedmineCharts::GroupingUtils.types
    grouping = RedmineCharts::GroupingUtils.from_params(types, {})
    grouping.should == nil
  end

  it "should return_nil_when_param_include_wrong_grouping" do
    types = RedmineCharts::GroupingUtils.types
    grouping = RedmineCharts::GroupingUtils.from_params(types, {:grouping => :other})
    grouping.should == nil
  end

  it "should return_proper_grouping_from_params" do
    types = RedmineCharts::GroupingUtils.types
    grouping = RedmineCharts::GroupingUtils.from_params(types, {:grouping => :user_id})
    grouping.should == :user_id
  end

  it "should return_proper_grouping_from_string_params" do
    types = RedmineCharts::GroupingUtils.types
    grouping = RedmineCharts::GroupingUtils.from_params(types, {:grouping => "tracker_id"})
    grouping.should == :tracker_id
  end

end
end
