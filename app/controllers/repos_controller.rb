class ReposController < ApplicationController
  def index
    @repos = Repo.non_archived
  end
end
