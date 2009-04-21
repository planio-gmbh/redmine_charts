class ChartsBurndownController < ChartsController

  unloadable
  
  protected

  def get_data(conditions, grouping, range)
    prepare_ranged = RedmineCharts::RangeUtils.prepare_range(range, "start_date")

    estimated = []
    logged = []
    remaining = []
    predicted = []
    done = []
    max = 0

    # get data for estimated hours

    j = 0
    estimated_hours_rows = Issue.all(:select => "sum(issues.estimated_hours) as hours, case when start_date is null then created_on else start_date end as issue_date", :conditions => conditions, :group => :issue_date, :order => :issue_date)

    prepare_ranged[:dates].each_with_index do |date,i|
      hours = i > 0 ? estimated[i-1][0] : 0
      for k in j..(estimated_hours_rows.size - 1)
        if estimated_hours_rows[k].issue_date.to_time <= date[1]
          hours += estimated_hours_rows[k].hours.to_i
          j += 1
        else
          break
        end
      end
                        
      estimated[i] = [hours, l(:charts_burndown_hint_estimated, { :estimated_hours => hours })]
      max = hours if max < hours
    end

    # get data for logged hours
    
    j = 0
    logged_hours_rows = TimeEntry.all(:select => "sum(time_entries.hours) as hours, spent_on", :conditions => conditions, :group => :spent_on, :order => :spent_on)

    prepare_ranged[:dates].each_with_index do |date,i|
      hours = i > 0 ? logged[i-1][0] : 0
      for k in j..(logged_hours_rows.size - 1)
        if logged_hours_rows[k].spent_on.to_time <= date[1]
          hours += logged_hours_rows[k].hours.to_i
          j += 1
        else
          break
        end
      end    
      logged[i] = [hours, l(:charts_burndown_hint_logged, { :logged_hours => hours })]
      max = hours if max < hours
    end

    # get data for done ratio, remaining and predicted hours

    prepare_ranged[:dates].each_with_index do |date,i|    
      rows = JournalDetail.find_by_sql(["select sum(journal_details.value*issues.estimated_hours)/sum(issues.estimated_hours) as ratio_done from (select max(journal_details.id) as journal_details_id, journals.journalized_id as issue_id from issues left join journals on journals.journalized_id = issues.id and journals.journalized_type ='Issue' left join journal_details on journals.id = journal_details.journal_id and journal_details.prop_key = 'done_ratio' where issues.project_id in (?) and (journals.id is null or journals.created_on <= ?) group by issues.id) left join issues on issues.id = issue_id left join journal_details on journal_details.id = journal_details_id", conditions[:project_id], date[1]])
      if rows 
        ratio_done = rows[0].ratio_done
      end
      done[i] = ratio_done.to_i
      
      remaining_hours = done[i] > 0 ? logged[i][0]/done[i]*(100-done[i]) : estimated[i][0]
      
      remaining[i] = [remaining_hours, l(:charts_burndown_hint_remaining, { :remaining_hours => remaining_hours, :work_done => done[i] })]
      
      predicted_hours = logged[i][0] + remaining[i][0]
      
      if predicted_hours.to_i > estimated[i][0].to_i
        predicted[i] = [predicted_hours, l(:charts_burndown_hint_predicted_over_estimation, { :remaining_hours => predicted_hours, :hours_over_estimation => predicted_hours - estimated[i][0] }), true]
      else
        predicted[i] = [predicted_hours, l(:charts_burndown_hint_predicted, { :remaining_hours => predicted_hours })]
      end
      
      max = predicted_hours if max < predicted_hours
    end

    sets = [
      [l(:charts_burndown_group_estimated), estimated],
      [l(:charts_burndown_group_logged), logged],
      [l(:charts_burndown_group_remaining), remaining],
      [l(:charts_burndown_group_predicted), predicted],
    ]

    {
      :labels => prepare_ranged[:labels],
      :count => prepare_ranged[:steps],
      :max => max,
      :sets => sets
    }
  end

  def get_title
    l(:charts_link_burndown)
  end
  
  def get_help
    l(:charts_burndown_help)
  end
  
  def get_x_legend
    l(:charts_burndown_x)
  end
  
  def get_y_legend
    l(:charts_burndown_y)
  end
  
  def show_x_axis
    true
  end
  
  def show_y_axis
    true
  end
  
  def show_date_condition
    true
  end
  
  def get_grouping_options
    []
  end
  
  def get_conditions_options
    []
  end
  
end
