namespace :repo do
  desc "Go through all non-archived repositories and open PRs with any missing contributing docs"
  task :open_prs, [:dry_run] => :environment do |_, args|
    dry_run = args[:dry_run].to_s.casecmp?("dry_run")
    repos_needing_action = 0
    opened_prs = 0

    repos = Repo.non_archived
    puts "Total #{repos.size}"

    repos.each do |repo|
      next unless repo.needs_action?

      repos_needing_action += 1
      pull_request = PullRequestCreator.new(repo.name).open_pull_request unless dry_run
      puts "Created pull request #{pull_request&.html_url}"
      opened_prs += 1
    rescue => e
      puts "Error! #{e.message} on #{repo.html_url}"
      Rails.logger.error("Error creating pull request on #{repo.name}: #{e.message}")
    end

    puts "Found #{repos_needing_action} repos needing action."
    puts "Opened #{opened_prs}"
  end
end
