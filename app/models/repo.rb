class Repo
  attr_reader :json

  def initialize(json)
    @json = json
  end

  def name
    json["name"]
  end

  def url
    json["url"]
  end

  def archived?
    json["isArchived"]
  end

  def has_contributing_guidelines?
    default_branch_has_file?("CONTRIBUTING.md")
  end

  def has_code_of_conduct?
    default_branch_has_file?("CODE_OF_CONDUCT.md")
  end

  private

  def default_branch_has_file?(name)
    !!default_branch_tree_entry_names&.include?(name)
  end

  def default_branch_tree_entry_names
    json.dig("defaultBranchRef", "target", "tree", "entries")
      &.map { |entry| entry["name"] }
  end

  class << self
    def all
      repos = []
      after = nil

      loop do
        connection = load_repositories_connection(after: after)

        repos += connection["nodes"].map { |repo_json|
          new(repo_json)
        }

        page_info = connection["pageInfo"]
        after = page_info["endCursor"]
        break unless page_info["hasNextPage"]
      end

      repos
    end

    def non_archived
      all.reject(&:archived?)
    end

    def load_repositories_connection(after:)
      query = graphql_query(after: after)
      body = JSON.dump(query: query)

      uri = URI("https://api.github.com/graphql")
      headers = {"Authorization" => "token #{ENV["GITHUB_ACCESS_TOKEN"]}"}
      response = Net::HTTP.post(uri, body, headers)

      raise "Not success: #{response}" unless response.is_a?(Net::HTTPSuccess)

      JSON.parse(response.body).dig("data", "organization", "repositories")
    end

    def graphql_query(after:)
      <<-GRAPHQL
    {
      organization(login: "dxw") {
        repositories(first: 100, orderBy: { field: NAME, direction: ASC }#{", after: \"#{after}\"" if after}) {
          nodes {
            id
            name
            url
            isArchived
            defaultBranchRef {
              target {
                ... on Commit {
                  tree {
                    entries {
                      name
                    }
                  }
                }
              }
            }
          }
          pageInfo {
            hasNextPage
            endCursor
          }
        }
      }
    }
      GRAPHQL
    end
  end
end
