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
      if !repo.can_be_written_to?
        puts "Manual action needed: dxw-rails-user cannot open a pull request for #{repo.name}."
        next
      end

      pull_request = PullRequestCreator.new(repo.name).open_pull_request unless dry_run
      if pull_request
        puts "Created pull request #{pull_request.html_url}"
        opened_prs += 1
      end
    rescue => e
      puts "Error creating pull request on #{repo.url}: #{e.message}"
      Rails.logger.error("Error creating pull request on #{repo.name}: #{e.message}")
    end

    puts "Found #{repos_needing_action} repos needing action."
    puts "Opened #{opened_prs}" unless dry_run
  end
end
