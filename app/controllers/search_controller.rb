class SearchController < ApplicationController
  before_action :init_octokit

  def index
    if params[:search]
      issue_count = {}
      issues = Octokit.issues params[:search]
      issues.map{ |x|
        issue_type = time_class x[:created_at]
        case issue_type
        when 'new'
          issue_count['new'] ||= 0
          issue_count['new'] += 1
        when 'mid'
          issue_count['mid'] ||= 0
          issue_count['mid'] += 1
        when 'old'
          issue_count['old'] ||= 0
          issue_count['old'] += 1
        end
      }
      @values = issue_count.values
    end
  end

  private

  def init_octokit
    Octokit.auto_paginate = true
  end

  def time_class(time)
    date = time.to_date
    today = Date.today
    diff = (today - date).round

    case diff
    when 0..1
      'new'
    when 1..7
      'mid'
    else
      'old'
    end
  end
end
