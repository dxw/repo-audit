class PullRequestsController < ApplicationController
  def create
    pull_request = PullRequestCreator.new(params[:repo_name]).open_pull_request
    # TODO remove
    logger.info("Created pull request #{pull_request}")
  end
end
