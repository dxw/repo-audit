feature "Viewing a list of public repos" do
  around(:each) { |example| VCR.use_cassette("repos", &example) }

  scenario "The user views the first page of public, non-archived repos" do
    visit root_path

    expect(page).to have_text("Public repositories")

    expect(page).to have_table_row("Name" => ".github", "Has contributing guidelines" => "Yes", "Has code of conduct" => "Yes")
    expect(page).to have_table_row("Name" => "team-dashboard", "Has contributing guidelines" => "No", "Has code of conduct" => "No")

    expect(page).not_to have_text("staffie")
  end

  scenario "The user creates a pull request to add a code of conduct" do
    visit root_path

    within :table_row, {"Name" => "team-dashboard"} do
      click_on "Create pull request"
    end

    expect(page).to have_text "Pull request created for team-dashboard."
    # TODO HTTP mocking
  end
end
