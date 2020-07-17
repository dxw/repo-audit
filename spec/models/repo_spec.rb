RSpec.describe Repo do
  describe ".all" do
    it "returns the first 100 public repos, in ascending name order" do
      VCR.use_cassette("repos") do
        repos = Repo.all

        expect(repos.length).to eq(100)
        expect(repos.first.name).to eq(".github")
        expect(repos.last.name).to eq("homebrew-tap")
      end
    end
  end
end
