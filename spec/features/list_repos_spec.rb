feature "Viewing a list of public repos" do
  scenario "The user views the first page of public repos" do
    VCR.use_cassette("repos") do
      visit root_path

      expect(page).to have_text("Public repositories")

      expect(page).to have_table_row("Name" => ".github", "Has contributing guidelines" => "Yes", "Has code of conduct" => "Yes")
      expect(page).to have_table_row("Name" => "10000ft-scheduling-dashboard", "Has contributing guidelines" => "No", "Has code of conduct" => "No")
    end
  end
end
