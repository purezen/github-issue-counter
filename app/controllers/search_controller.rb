class SearchController < ApplicationController
  before_action :init_octokit

  def index
    if params[:search]
      date_count = {today: 0, within7days: 0, earlier: 0}
      issue_times = @client.list_issues(params[:search]).select{ |x| !x[:pull_request] }
                    .map{ |x| x[:created_at] }
      issue_times.map{|x|
        if x > 24.hours.ago
          date_count[:today] += 1
        elsif x > 7.days.ago
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
end
