require File.dirname(__FILE__) + '/../spec_helper'

describe "RangeUtils" do

  before do
    Time.set_current_date = Time.mktime(2010,3,3)
  end

  it "should return_range_types" do
    RedmineCharts::RangeUtils.types.should == [ :months, :weeks, :days ]
  end

  it "should set_range_if_not_provided_in_params" do
    RedmineCharts::RangeUtils.from_params({}).should be_nil
  end

  it "should read_range_type_from_params" do
    RedmineCharts::RangeUtils.from_params({ :range => "days" }).should be_nil
  end

  it "should read_range_offset_from_params" do
    RedmineCharts::RangeUtils.from_params({ :offset => "1" }).should be_nil
  end

  it "should read_range_limit_from_params" do
    RedmineCharts::RangeUtils.from_params({ :limit => "11" }).should be_nil
  end

  it "should read_range_from_params" do
    range = RedmineCharts::RangeUtils.from_params({ :offset => "2", :range => "months", :limit => "11" })
    range[:range].should == :months
    range[:offset].should == 2
    range[:limit].should == 11
  end

  it "should propose_range_for_today" do
    range = RedmineCharts::RangeUtils.propose_range({ :week => "2010009", :month => "201003", :day => "2010062" })
    range[:range].should == :days
    range[:offset].should == 0
    range[:limit].should == 11
  end

  it "should propose_range_for_10_days_ago" do
    range = RedmineCharts::RangeUtils.propose_range({ :week => "2010008", :month => "2010003", :day => "2010052" })
    range[:range].should == :days
    range[:offset].should == 0
    range[:limit].should == 11
  end

  it "should propose_range_for_20_days_ago" do
    range = RedmineCharts::RangeUtils.propose_range({ :week => "2010007", :month => "2010003", :day => "2010042" })
    range[:range].should == :days
    range[:offset].should == 0
    range[:limit].should == 21
  end

  it "should propose_range_for_21_days_ago" do
    range = RedmineCharts::RangeUtils.propose_range({ :week => "2010006", :month => "2010003", :day => "2010041" })
    range[:range].should == :weeks
    range[:offset].should == 0
    range[:limit].should == 11
  end

  it "should propose_range_for_20_weeks_ago" do
    range = RedmineCharts::RangeUtils.propose_range({ :week => "2009042", :month => "2009011", :day => "2009300" })
    range[:range].should == :weeks
    range[:offset].should == 0
    range[:limit].should == 21
  end

  it "should propose_range_for_21_weeks_ago" do
    range = RedmineCharts::RangeUtils.propose_range({ :week => "2009040", :month => "2009011", :day => "2009300" })
    range[:range].should == :months
    range[:offset].should == 0
    range[:limit].should == 11
  end

  it "should propose_range_for_21_months_ago" do
    range = RedmineCharts::RangeUtils.propose_range({ :week => "2009039", :month => "2008001", :day => "2009300" })
    range[:range].should == :months
    range[:offset].should == 0
    range[:limit].should == 27
  end

  it "should prepare_range_for_days" do
    range = RedmineCharts::RangeUtils.prepare_range({ :range => :days, :limit => 10, :offset => 0 })
    range[:range].should == :days
    range[:keys].size.should == 10
    range[:keys][0].should == "2010053"
    range[:keys][1].should == "2010054"
    range[:keys][2].should == "2010055"
    range[:keys][3].should == "2010056"
    range[:keys][4].should == "2010057"
    range[:keys][5].should == "2010058"
    range[:keys][6].should == "2010059"
    range[:keys][7].should == "2010060"
    range[:keys][8].should == "2010061"
    range[:keys][9].should == "2010062"
    range[:min].should == "2010053"
    range[:max].should == "2010062"
    range[:labels].size.should == 10
    range[:labels][0].should == "22 Feb 10"
    range[:labels][1].should == "23 Feb 10"
    range[:labels][2].should == "24 Feb 10"
    range[:labels][3].should == "25 Feb 10"
    range[:labels][4].should == "26 Feb 10"
    range[:labels][5].should == "27 Feb 10"
    range[:labels][6].should == "28 Feb 10"
    range[:labels][7].should == "01 Mar 10"
    range[:labels][8].should == "02 Mar 10"
    range[:labels][9].should == "03 Mar 10"

  end

  it "should prepare_range_for_days_with_offset" do
    range = RedmineCharts::RangeUtils.prepare_range({ :range => :days, :limit => 10, :offset => 5 })
    range[:range].should == :days
    range[:min].should == "2010048"
    range[:max].should == "2010057"
  end

  it "should prepare_range_for_days_with_year_difference" do
    range = RedmineCharts::RangeUtils.prepare_range({ :range => :days, :limit => 60, :offset => 5 })
    range[:range].should == :days
    range[:min].should == "2009363" # 2009-12-29
    range[:max].should == "2010057"
    range[:keys][1].should == "2009364" # 2009-12-30
    range[:keys][2].should == "2009365" # 2009-12-31
    range[:keys][3].should == "2010001"
  end


  it "should prepare_range_for_weeks" do
    range = RedmineCharts::RangeUtils.prepare_range({ :range => :weeks, :limit => 5, :offset => 0 })
    range[:range].should == :weeks
    range[:min].should == "2010005"
    range[:max].should == "2010009"
  end

  it "should prepare_range_for_weeks_with_offset" do
    range = RedmineCharts::RangeUtils.prepare_range({ :range => :weeks, :limit => 5, :offset => 1 })
    range[:range].should == :weeks
    range[:min].should == "2010004"
    range[:max].should == "2010008"
  end

  it "should prepare_range_for_weeks_with_year_difference" do
    range = RedmineCharts::RangeUtils.prepare_range({ :range => :weeks, :limit => 15, :offset => 1 })
    range[:range].should == :weeks
    range[:min].should == "2009046" # 2009-11-18
    range[:max].should == "2010008"
    range[:keys].size.should == 15
    range[:keys][0].should == "2009046" # 2009-11-18
    range[:keys][4].should == "2009050" # 2009-12-16
    range[:keys][5].should == "2009051" # 2009-12-23
    range[:keys][6].should == "2009052" # 2009-12-30
    range[:keys][7].should == "2010001"
    range[:keys][14].should == "2010008"
    range[:labels].size.should == 15
    range[:labels][2].should == "30 Nov - 6 Dec 09"
    range[:labels][5].should == "21 - 27 Dec 09"
    range[:labels][6].should == "28 Dec 09 - 3 Jan 10"
    range[:labels][7].should == "4 - 10 Jan 10" # 2010-01-05
    range[:labels][8].should == "11 - 17 Jan 10" # 2010-01-12
  end

  it "should prepare_range_for_months" do
    range = RedmineCharts::RangeUtils.prepare_range({ :range => :months, :limit => 2, :offset => 0 })
    range[:range].should == :months
    range[:min].should == "2010002"
    range[:max].should == "2010003"
    range[:keys].size.should == 2
    range[:keys][0].should == "2010002"
    range[:keys][1].should == "2010003"
    range[:labels].size.should == 2
    range[:labels][0].should == "Feb 10"
    range[:labels][1].should == "Mar 10"
  end

  it "should prepare_range_for_months_with_offset" do
    range = RedmineCharts::RangeUtils.prepare_range({ :range => :months, :limit => 1, :offset => 1 })
    range[:range].should == :months
    range[:min].should == "2010002"
    range[:max].should == "2010002"
  end

  it "should prepare_range_for_months_with_year_difference" do
    range = RedmineCharts::RangeUtils.prepare_range({ :range => :months, :limit => 3, :offset => 1 })
    range[:range].should == :months
    range[:min].should == "2009012"
    range[:max].should == "2010002"
    range[:keys][0].should == "2009012"
    range[:keys][1].should == "2010001"
  end

  it "should prepare_range_for_months_with_2_year_difference" do
    range = RedmineCharts::RangeUtils.prepare_range({ :range => :months, :limit => 16, :offset => 1 })
    range[:range].should == :months
    range[:min].should == "2008011"
    range[:max].should == "2010002"
    range[:keys][1].should == "2008012"
    range[:keys][2].should == "2009001"
    range[:keys][13].should == "2009012"
    range[:keys][14].should == "2010001"
  end

  it "should prepare_range_for_100_months" do
    range = RedmineCharts::RangeUtils.prepare_range({ :range => :months, :limit => 100, :offset => 1 })
    range[:range].should == :months
    range[:min].should == "2001011"
    range[:max].should == "2010002"
  end

  it "should prepare_range_for_100_weeks" do
    range = RedmineCharts::RangeUtils.prepare_range({ :range => :weeks, :limit => 100, :offset => 1 })
    range[:range].should == :weeks
    range[:min] # 2008-04-02.should == "2008013"
    range[:max].should == "2010008"
  end

  it "should prepare_range_for_100_days" do
    range = RedmineCharts::RangeUtils.prepare_range({ :range => :days, :limit => 100, :offset => 1 })
    range[:range].should == :days
    range[:min] # 2009-11-23.should == "2009327"
    range[:max].should == "2010061"
  end

end
