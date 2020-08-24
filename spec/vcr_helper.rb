require "vcr"

VCR.configure do |config|
  config.cassette_library_dir = "spec/vcr_cassettes"
  config.hook_into :webmock

  config.filter_sensitive_data("<GITHUB_ACCESS_TOKEN>") do |interaction|
    interaction.request.headers["Authorization"]&.first
  end
end
