RSpec.describe Repo do
  around(:each) { |example| VCR.use_cassette("repos", &example) }

  describe ".all" do
    it "returns all public repos, in ascending name order" do
      repos = Repo.all

      expect(repos.length).to eq(239)
      expect(repos.first.name).to eq(".github")
      expect(repos.last.name).to eq("zendesk_to_airtable")
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
      repo = Repo.all.find { |repo| repo.name == "dxw-deactivated-users" }

      expect(repo.has_contributing_guidelines?).to eq(false)
    end
  end

  describe "#has_code_of_conduct?" do
    it "returns true when there is a CODE_OF_CONDUCT.md on the default branch" do
      repo = Repo.all.find { |repo| repo.name == ".github" }

      expect(repo.has_code_of_conduct?).to eq(true)
    end

    it "returns false when there is not a CODE_OF_CONDUCT.md on the default branch" do
      repo = Repo.all.find { |repo| repo.name == "10000ft-scheduling-dashboard" }

      expect(repo.has_code_of_conduct?).to eq(false)
    end

    it "returns false when the repository has no default branch" do
      repo = Repo.all.find { |repo| repo.name == "dxw-deactivated-users" }

      expect(repo.has_code_of_conduct?).to eq(false)
    end
  end
end
