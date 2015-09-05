class SearchController < ApplicationController
  before_action :init_octokit

  def index
    if params[:search]
      date_count = {today: 0, within7days: 0, earlier: 0}
      issue_times = @client.list_issues(params[:search]).select{ |x| !x[:pull_request] }
                    .map{ |x| x[:created_at].in_time_zone('Chennai') }
      offsets = issue_times.map{|x| day_offset x}
      offsets.map{|x|
        case x
        when 0
          date_count[:today] += 1
        when 1..6
          date_count[:within7days] += 1
        else
          date_count[:earlier] += 1
        end
      }
      @values = date_count.values
    end
  end

  private

  def init_octokit
    Octokit.auto_paginate = true
  end

  def day_offset(time)
    (Date.today - time.in_time_zone("Chennai").to_date).round
  end
end
