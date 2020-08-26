RSpec.describe Repo do
  include GithubStubRequests

  let(:fake_github_client) { double(:client) }
  let(:repo) { Repo.all.find { |repo| repo.name == ".github" } }

  before do
    stub_github_client
    stub_pull_requests
  end

  around(:each) { |example| VCR.use_cassette("repos", &example) }

  describe ".all" do
    it "returns all public repos, in ascending name order" do
      repos = Repo.all

      expect(repos.length).to eq(247)
      expect(repos.first.name).to eq(".github")
      expect(repos.last.name).to eq("zendesk_to_airtable")
    end
  end

  describe ".non_archived" do
    it "returns all public repos, in ascending name order, excluding archived repos" do
      repos = Repo.non_archived

      expect(repos.length).to eq(152)
      expect(repos.first.name).to eq(".github")
      expect(repos.last.name).to eq("zendesk_to_airtable")

      expect(repos.map(&:name)).not_to include("staffie")
    end
  end

  describe "#has_contributing_guidelines?" do
    it "returns true when there is a CONTRIBUTING.md on the default branch" do
      repo = Repo.all.find { |repo| repo.name == ".github" }

      expect(repo.has_contributing_guidelines?).to eq(true)
    end

    it "returns false when there is not a CONTRIBUTING.md on the default branch" do
      repo = Repo.all.find { |repo| repo.name == "10000ft-scheduling-dashboard" }

      expect(repo.has_contributing_guidelines?).to eq(false)
    end

    it "returns false when the repository has no default branch" do
      repo = Repo.all.find { |repo| repo.name == "terraform-aws-ecs-logspout-logstash" }

      expect(repo.has_contributing_guidelines?).to eq(false)
    end
  end

  describe "#has_code_of_conduct?" do
    it "returns true when there is a CODE_OF_CONDUCT.md on the default branch" do
      repo = Repo.all.find { |repo| repo.name == ".github" }

      expect(repo.has_code_of_conduct?).to eq(true)
    end

    it "returns false when there is not a CODE_OF_CONDUCT.md on the default branch" do
      repo = Repo.all.find { |repo| repo.name == "team-dashboard" }

      expect(repo.has_code_of_conduct?).to eq(false)
    end

    it "returns false when the repository has no default branch" do
      repo = Repo.all.find { |repo| repo.name == "terraform-aws-ecs-logspout-logstash" }

      expect(repo.has_code_of_conduct?).to eq(false)
    end
  end

  describe "#archived?" do
    it "returns true when the repo is archived" do
      repo = Repo.all.find { |repo| repo.name == "staffie" }

      expect(repo.archived?).to eq(true)
    end

    it "returns false when the repo is not archived" do
      repo = Repo.all.find { |repo| repo.name == "team-dashboard" }

      expect(repo.archived?).to eq(false)
    end
  end

  describe "#has_contributing_pr?" do
    it "looks for an open pull request for a specific branch name" do
      expect(fake_github_client).to receive(:pull_requests)
        .with("dxw/.github", head: "dxw:#{PullRequestCreator::BRANCH_NAME}")

      repo.has_contributing_pr?
    end

    it "is false" do
      expect(repo.has_contributing_pr?).to be_falsey
    end

    context "when there is an open PR to add contributing documentation" do
      before do
        stub_pull_requests([double(:pull_request)])
      end

      it "is true" do
        expect(repo.has_contributing_pr?).to be_truthy
      end
    end
  end

  describe "#contributing_pr_link" do
    let(:pr) { double(:pull_request, url: "https://api.github.com/etc", html_url: "https://github.com/etc") }

    it "is the public URL of the existing PR" do
      stub_pull_requests([pr])

      expect(repo.contributing_pr_link).to match("https://github.com/")
    end
  end

  describe "#needs_action?" do
    it "is false if there is already an open contributing PR" do
      stub_pull_requests([double(:pull_request)])

      expect(repo.needs_action?).to be_falsey
    end

    it "is false if the repo already has the full contributing documentation" do
      expect(repo.needs_action?).to be_falsey
    end
  end

  describe "#can_be_written_to?" do
    let(:fake_permission) { double(:permission, permission: permission_level) }

    context "when the service account doesn't have write permissions on the repo" do
      let(:permission_level) { "read" }
      before do
        stub_permission_check
      end

      it "is false" do
        expect(repo.can_be_written_to?).to be_falsey
      end
    end

    context "when the service account doesn't have push access to the repo" do
      before do
        stub_permission_forbidden
      end

      it "is false" do
        expect(repo.can_be_written_to?).to be_falsey
      end
    end

    context "when the service account has write permissions on the repo" do
      let(:permission_level) { "write" }
      before do
        stub_permission_check
      end

      it "is true" do
        expect(repo.can_be_written_to?).to be_truthy
      end
    end
  end
end
