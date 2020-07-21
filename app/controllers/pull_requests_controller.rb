class PullRequestsController < ApplicationController
  def create
    pull_request = PullRequest.create(params[:repo_name])
    # TODO remove
    logger.info("Created pull request #{pull_request}")
  end
end
