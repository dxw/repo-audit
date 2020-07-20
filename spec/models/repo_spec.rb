RSpec.describe Repo do
  describe ".all" do
    it "returns all public repos, in ascending name order" do
      VCR.use_cassette("repos") do
        repos = Repo.all

        expect(repos.length).to eq(239)
        expect(repos.first.name).to eq(".github")
        expect(repos.last.name).to eq("zendesk_to_airtable")
      end
    end
  end
end
