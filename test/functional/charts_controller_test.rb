require File.dirname(__FILE__) + '/../test_helper'
require 'charts_controller'

class ChartsController

  def rescue_action(e)
    raise e
  end

  def authorize
    true
  end

  def get_data_value
    @data
  end

end

class ChartsControllerTest < ActionController::TestCase

  include Redmine::I18n

  protected

  def get_data options = {}
    get :index, options
    assert_response :success
    ActiveSupport::JSON.decode(@controller.get_data_value)
  end

#  def get_day_labels(date_from)
#    return date_from.strftime("%d %b %y")
#  end
#
#  def get_month_labels(date_from)
#    return date_from.strftime("%b %y")
#  end
#
#  def get_week_labels(date_from)
#    day_from = date_from.strftime("%d").to_i
#    month_from = date_from.strftime("%b")
#    year_from = date_from.strftime("%y")
#
#    date_to = date_from + 6.days
#
#    day_to = date_to.strftime("%d").to_i
#    month_to = date_to.strftime("%b")
#    year_to = date_to.strftime("%y")
#
#    if year_from != year_to
#      return "#{day_from} #{month_from} #{year_from} - #{day_to} #{month_to} #{year_to}"
#    elsif month_from != month_to
#      return "#{day_from} #{month_from} - #{day_to} #{month_to} #{year_from}"
#    else
#      return "#{day_from} - #{day_to} #{month_from} #{year_from}"
#    end
#  end
  
end
