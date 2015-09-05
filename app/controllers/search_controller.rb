class SearchController < ApplicationController
  before_action :init_octokit

  def index
    if params[:search]
      issue_count = {}
      issue_dates = @client.list_issues(params[:search]).select{ |x| !x[:pull_request] }
                    .map{ |x| x[:created_at].in_time_zone('Chennai').to_date }
      issue_dates.map{ |x|
        date_class = date_class x
        case date_class
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
    @client ||= Octokit::Client.new(access_token: "14aa014d7f548986d00b50298cf1312b7aa41ca7")
    Octokit.auto_paginate = true
  end

  def date_class(date)
    today = Date.today
    diff = (today - date).round
    case diff
    when 0
      'new'
    when 1..7
      'mid'
    else
      'old'
    end
  end
end
