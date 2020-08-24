RSpec.describe PullRequestCreator do
  describe ".create" do
    context "when contributing guidelines and code of conduct are absent" do
      it "creates a branch and opens a pull request" do
        pull_request = VCR.use_cassette("create_pull_request") {
          PullRequestCreator.new("repo-audit-test").open_pull_request
        }

        expected_commit_message = <<~MESSAGE
          Add contributing-related documentation

          These files are required by dxw tech team RFC 28 [1]. The content is
          taken from commit 002ebd0 of [2].

          This commit was generated by dxw’s repo-audit [3].

          [1] https://github.com/dxw/tech-team-rfcs/blob/master/rfc-028-adopt-a-code-of-conduct.md
          [2] https://github.com/dxw/.github
          [3] https://github.com/dxw/repo-audit
        MESSAGE

        # We can't use stub_request because that stops the VCR response from coming through
        create_commit = a_request(:post, "https://api.github.com/repos/dxw/repo-audit-test/git/commits").with(body: hash_including(message: expected_commit_message))
        expect(create_commit).to have_been_made

        expected_body = <<~MESSAGE
          These files are required by [dxw tech team RFC 28](https://github.com/dxw/tech-team-rfcs/blob/master/rfc-028-adopt-a-code-of-conduct.md). The content is taken from dxw/.github@002ebd0cfe8862e741de64b9b6ee675d2eced840.

          This pull request was generated by dxw’s [repo-audit](https://github.com/dxw/repo-audit).
        MESSAGE

        expect(pull_request.title).to eq("Add contributing-related documentation")
        expect(pull_request.body).to eq(expected_body)
        expect(pull_request.html_url).to eq("https://github.com/dxw/repo-audit-test/pull/8")

        # TODO expect tree, commit, branch to have been created, how to check they're all glued together properly?
        # TODO how to check the contents of the PR
        # TODO expect PR to have been created
      end
    end
  end
end
