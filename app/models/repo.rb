Repo = Struct.new(:id, :name) {
  class << self
    def all
      repos = []
      after = nil

      loop do
        connection = load_repositories_connection(after: after)

        repos += connection["nodes"].map { |repo_json|
          new(repo_json["id"], repo_json["name"])
        }

        page_info = connection["pageInfo"]
        after = page_info["endCursor"]
        break unless page_info["hasNextPage"]
      end

      repos
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
}
