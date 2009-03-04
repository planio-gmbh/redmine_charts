module RedmineCharts
  module ConditionsUtils

    include Redmine::I18n

    @@default_types = [ :user_id, :issue_id, :activity_id, "issues.category_id".to_sym ]

    def self.default_types
      @@default_types
    end

    def self.from_params(params, options)
      conditions = {:project_id => project_and_its_children_ids(params[:project_id], params[:include_subprojects])}
      options.each do |k|
        t = params["conditions_#{k.to_s}".to_sym].blank? ? nil : Integer(params["conditions_#{k.to_s}".to_sym])
        conditions[k] = t if t and t > 0
      end   
      conditions
    end

    def self.to_options(options, project_id)
      options.collect do |i|
        case i
        when :user_id then 
          users = {}          
          project_and_its_children_ids(project_id).each do |pid|
            Project.find(pid).assignable_users.each do |u|
              users[u.login] = u.id
            end
          end
          
          [:user_id, users.to_a.unshift([l(:charts_condition_all), 0])]
        when :issue_id then [:issue_id, nil]
        when :activity_id then [:activity_id, Enumeration.values("ACTI").collect { |a| [a.name.downcase, a.id] }.unshift([l(:charts_condition_all), 0])]
        when "issues.category_id".to_sym then ["issues.category_id".to_sym, IssueCategory.find_all_by_project_id(project_and_its_children_ids(project_id)).collect { |c| [c.name.downcase, c.id] }.unshift([l(:charts_condition_all), 0])]
        end
      end
    end
    
    private 
    
    def self.project_and_its_children_ids(project_id, include_subprojects = true)       
      project = Project.find(project_id)
      if include_subprojects
        [project.id, project_children_ids(project)].flatten
      else
        [project.id]
      end
    end
    
    def self.project_children_ids(project)
      project.children.collect { |child| [child.id, project_children_ids(child)] }
    end

  end
end
