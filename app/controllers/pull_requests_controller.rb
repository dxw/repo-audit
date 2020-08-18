class PullRequestsController < ApplicationController
  def create
    pull_request = PullRequestCreator.new(params[:repo_name]).open_pull_request
    # TODO remove
    logger.info("Created pull request #{pull_request.inspect}")

    flash[:info] = "Created pull request #{pull_request.inspect}"
  rescue StandardError => e
    # TODO remove?
    logger.error("Error creating pull request: #{e.messages}")

    flash[:error] = "Encountered an error creating the pull request. The error was #{e.messages}"
  end
end
