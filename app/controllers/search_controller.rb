class SearchController < ApplicationController
  before_action :init_octokit

  def index
    if params[:search]
      date_count = {new: 0, mid: 0, old: 0}
      issue_times = @client.list_issues(params[:search]).select{ |x| !x[:pull_request] }
                    .map{ |x| x[:created_at].in_time_zone('Chennai') }
      issue_times.map{ |x|
        case x
        when 24.hours.ago < x
          date_count[:new] += 1
        when 7.days.ago < x
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
    Octokit.auto_paginate = true
  end
end
