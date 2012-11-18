require File.dirname(__FILE__) + '/../spec_helper'

module RedmineCharts
describe ConditionsUtils do

  it "should return_project_its_subprojects_ids" do
    RedmineCharts::ConditionsUtils.project_and_its_children_ids(15041).should == [15041,15042]
  end

  it "should return_conditions_types" do
    RedmineCharts::ConditionsUtils.types.should == [ :issue_ids, :project_ids, :user_ids, :category_ids, :status_ids, :activity_ids, :fixed_version_ids, :tracker_ids, :priority_ids, :author_ids, :assigned_to_ids ]
  end

  it "should return_proper_conditions" do
    #types = RedmineCharts::ConditionsUtils.types
    #options = RedmineCharts::ConditionsUtils.to_options(types)

    #options[:user_ids] = options[:user_ids].select { |u| u[1] != 9 }
    #options[:assigned_to_ids] = options[:assigned_to_ids].select { |u| u[1] != 9 }
    #options[:author_ids] = options[:author_ids].select { |u| u[1] != 9 }

    #options[:issue_ids], 'Issue condition'.should be_nil
    #options[:project_ids], 'Project condition'.should == [["Project1", 15041], ["Project2", 15042], ["Project3", 15043], ["Project4", 15044]]
    #options[:user_ids],'User condition'.should == [["Anonymous", 6], ["Dave Lopper", 3], ["Dave2 Lopper2", 5], ["John Smith", 2], ["redMine Admin", 1], ["Robert Hill", 4], ["Some One", 7], ["User Misc", 8]]
    #options[:assigned_to_ids],'Owner condition'.should == [["Anonymous", 6], ["Dave Lopper", 3], ["Dave2 Lopper2", 5], ["John Smith", 2], ["redMine Admin", 1], ["Robert Hill", 4], ["Some One", 7], ["User Misc", 8]]
    #options[:author_ids],'Author condition'.should == [["Anonymous", 6], ["Dave Lopper", 3], ["Dave2 Lopper2", 5], ["John Smith", 2], ["redMine Admin", 1], ["Robert Hill", 4], ["Some One", 7], ["User Misc", 8]]
    #options[:activity_ids],'Activity condition'.should == [["Design", 9], ["Development", 10], ["Inactive Activity", 14], ["QA", 11]]
    #options[:category_ids],'Category condition'.should == [["Project1 - Category1", 15041], ["Project1 - Category2", 15042], ["Project2 - Category3", 15043], ["Project3 - Category4", 15044], ["Project4 - Category5", 15045]]
    #options[:fixed_version_ids],'Version condition'.should == [["Project1 - 1.0", 15041], ["Project1 - 2.0", 15042], ["Project4 - 2.0", 15043]]
    #options[:tracker_ids],'Tracker condition'.should == [["Bug", 1], ["Feature request", 2], ["Support request", 3]]
    #options[:priority_ids],'Priority condition'.should == [["High", 6], ["Immediate", 8], ["Low", 4], ["Normal", 5], ["Urgent", 7]]
    #options[:status_ids],'Status condition'.should == [["Assigned", 2], ["Closed", 5], ["Feedback", 4], ["New", 1], ["Rejected", 6], ["Resolved", 3]]
  end

  it "should set_project_ids_if_not_provided_in_params" do
    types = RedmineCharts::ConditionsUtils.types
    conditions = RedmineCharts::ConditionsUtils.from_params(types, 15041, {})
    conditions[:project_ids].should == [15041, 15042]
  end

  it "should set_project_ids_if_provided_empty_project_in_params" do
    types = RedmineCharts::ConditionsUtils.types
    conditions = RedmineCharts::ConditionsUtils.from_params(types, 15041, {:project_ids => []})
    conditions[:project_ids].should == [15041, 15042]
  end

  it "should set_project_ids_if_provided_wrong_in_params" do
    types = RedmineCharts::ConditionsUtils.types
    conditions = RedmineCharts::ConditionsUtils.from_params(types, 15041, {:project_ids => [0, nil, 15041, 15043, 15099],})
    conditions[:project_ids].should == [15041, 15043]
  end

  it "should read_project_ids_from_params" do
    types = RedmineCharts::ConditionsUtils.types
    conditions = RedmineCharts::ConditionsUtils.from_params(types, 15041, {:project_ids => [15041, 15042, 15043]})
    conditions[:project_ids].should == [15041,15042,15043]
  end

  it "should read_conditions_from_params" do
    types = RedmineCharts::ConditionsUtils.types
    conditions = RedmineCharts::ConditionsUtils.from_params(types, 15041, {:issue_ids => 66, :activity_ids => 12})
    conditions[:issue_ids].should == [66]
    conditions[:activity_ids].should == [12]

  end

  it "should read_multiple_conditions_from_params" do
    types = RedmineCharts::ConditionsUtils.types
    conditions = RedmineCharts::ConditionsUtils.from_params(types, 15041, {:category_ids => [3, 5, 7]})
    conditions[:category_ids].should == [3, 5, 7]
  end

  it "should remove_wrong_conditions_from_params" do
    types = RedmineCharts::ConditionsUtils.types
    conditions = RedmineCharts::ConditionsUtils.from_params(types, 15041, {:tracker_ids => [3, 0, nil, 7]})
    conditions[:tracker_ids].should == [3, 7]
  end

  it "should set_nil_instead_of_empty_array_for_conditions_from_params" do
    types = RedmineCharts::ConditionsUtils.types
    conditions = RedmineCharts::ConditionsUtils.from_params(types, 15041, {:user_ids => 0, :issue_ids => nil, :author_ids => [0], :priority_ids => [nil], :status_ids => []})
    conditions[:user_ids].should be_nil
    conditions[:issue_ids].should be_nil
    conditions[:author_ids].should be_nil
    conditions[:status_ids].should be_nil
    conditions[:priority_ids].should be_nil
    conditions[:fixed_version_ids].should be_nil
  end

end
end
