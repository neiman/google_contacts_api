# Module that implements a method to get groups for a user
module GoogleContactsApi
  module Groups
    # Retrieve the contacts for this user or group
    def get_groups(params = {})
      params = params.with_indifferent_access
      # compose params into a string
      # See http://code.google.com/apis/contacts/docs/3.0/reference.html#Parameters
      # alt, q, max-results, start-index, updated-min,
      # orderby, showdeleted, requirealldeleted, sortorder
      params["max-results"] = 100000 unless params.key?("max-results")

      # Set the version, for some reason the header is not effective on its own?
      # TODO: So weird thing, version 3 doesn't return system groups.
      # When it does, just remove this line
      params["v"] = 2

      url = "groups/default/full"
      response = @api.get(url, params)

      case GoogleContactsApi::Api.parse_response_code(response)
      # TODO: Better handle 401, 403, 404
      when 401; raise
      when 403; raise
      when 404; raise
      when 400...500; raise
      when 500...600; raise
      end
      GoogleContactsApi::GroupSet.new(response.body, @api)
    end
  end
end