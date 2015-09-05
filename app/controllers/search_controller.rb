class SearchController < ApplicationController
  before_action :init_octokit

  def index
    if params[:search]
      date_count = {new: 0, mid: 0, old: 0}
      issue_dates = @client.list_issues(params[:search]).select{ |x| !x[:pull_request] }
                    .map{ |x| x[:created_at].in_time_zone('Chennai').to_date }
      issue_dates.map{ |x|
        date_diff = date_diff x
        case date_diff
        when 0
          date_count[:new] += 1
        when 1..6
          date_count[:mid] += 1
        else
          date_count[:old] += 1
        end
      }
      @values = date_count.values
    end
  end

  private

  def init_octokit
    @client ||= Octokit::Client.new(access_token: "14aa014d7f548986d00b50298cf1312b7aa41ca7")
    Octokit.auto_paginate = true
  end

  def date_diff(date)
    today = Date.today
    diff = (today - date).round
  end
end
