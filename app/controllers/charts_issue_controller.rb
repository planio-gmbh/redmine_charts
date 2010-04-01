class ChartsIssueController < ChartsController

  unloadable
  
  protected

  def get_data
    @grouping ||= :status_id

    conditions = {}

    @conditions.each do |c, v|
      column_name = RedmineCharts::ConditionsUtils.to_column(c, 'issues')
      conditions[column_name] = v if v and column_name
    end

    group_column = RedmineCharts::GroupingUtils.to_column(@grouping, 'issues')

    rows = Issue.all(:select => "#{group_column || 0} as group_id, count(*) as issues_count", :conditions => conditions, :group => group_column)

    total_issues = 0

    rows.each do |row|
      total_issues += row.issues_count.to_i
    end

    labels = []
    set = []

    if rows.empty?
      labels << l(:charts_issue_label, { :label => l(:charts_issue_none) })
      set << [1, l(:charts_issue_hint, { :label => l(:charts_issue_none), :issues => 0, :percent => 0, :total_issues => 0 })]
    else
      rows.each do |row|
        labels << l(:charts_issue_label, { :label => RedmineCharts::GroupingUtils.to_string(row.group_id, @grouping, l(:charts_issue_others)) })
        hint = l(:charts_issue_hint, { :label => RedmineCharts::GroupingUtils.to_string(row.group_id, @grouping, l(:charts_issue_others)), :issues => row.issues_count, :percent => get_percent(row.issues_count, total_issues), :total_issues => total_issues })
        set << [row.issues_count.to_i, hint]
      end
    end

    {
      :labels => labels,
      :count => rows.size,
      :max => 0,
      :sets => {"" => set}
    }
  end

  def get_title
    l(:charts_link_ratio)
  end
  
  def get_help
    l(:charts_ratio_help)
  end
  
  def get_type
    :pie
  end

  def get_conditions_options
    RedmineCharts::ConditionsUtils.types - [:activity_ids, :issue_ids, :user_ids]
  end

  def get_grouping_options
    RedmineCharts::GroupingUtils.types - [:activity_id, :issue_id, :user_id]
  end

  private

  def get_percent(value, total)
    if total > 0      
      (value.to_f/total*100).round
    else
      0
    end
  end
  
end
