module GithubStubRequests
  def stub_github_client
    allow(Octokit::Client).to receive(:new)
      .and_return(fake_github_client)
  end

  def stub_pull_requests(pull_requests = [])
    allow(fake_github_client).to receive(:pull_requests)
      .and_return(pull_requests)
  end

  def stub_permission_check
    allow(fake_github_client).to receive(:permission_level).and_return(fake_permission)
  end

  def stub_permission_forbidden
    allow(fake_github_client).to receive(:permission_level).and_raise(Octokit::Forbidden)
  end
end
