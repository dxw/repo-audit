class ReposController < ApplicationController
  Repo = Struct.new(:id, :name)

  def index
    query = <<-GRAPHQL
    {
      organization(login: "dxw") {
        repositories(first: 100, orderBy: { field: NAME, direction: ASC }) {
          nodes {
            id
            name
          }
          pageInfo {
            endCursor
            startCursor
          }
        }
      }
    }
    GRAPHQL
    body = JSON.dump(query: query)

    uri = URI("https://api.github.com/graphql")
    headers = {"Authorization" => "token #{ENV["GITHUB_ACCESS_TOKEN"]}"}
    response = Net::HTTP.post(uri, body, headers)

    raise "Not success: #{response}" unless response.is_a?(Net::HTTPSuccess)

    data = JSON.parse(response.body)

    @repos = data["data"]["organization"]["repositories"]["nodes"].map { |repo_json|
      Repo.new(repo_json["id"], repo_json["name"])
    }
  end
end
