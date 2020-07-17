feature "Viewing a list of public repos" do
  scenario "The user views the first page of public repos" do
    VCR.use_cassette("repos") do
      visit root_path

      expect(page).to have_text("Public repositories")

      expect(page).to have_text(".github")
      expect(page).to have_text("10000ft-scheduling-dashboard")
    end
  end
end
