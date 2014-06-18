class PrettyClose::FacebookCheckinPages < PrettyClose

  def initialize_graph
    @block_type = "checkin_pages"
    @data = @graph.get_connections(@params[:facebook_user_id], "feed?fields=place")
  end

  def required_params
    [:auth_token, :facebook_user_id]
  end

  def send_data_to_pretty_close
    get_places_from_blocks.each do |place|
      begin
        @params_to_send = generate_params_to_send(place)
        req = Net::HTTP.post_form(URI.parse(url), @params_to_send)
        res = JSON.parse(req.body)
        @query.transactions.create!(
          url:      url,
          params:   @params_to_send,
          message:  res,
          status:   (res["success"].to_s == "true" ? :success : :error)
        )
      rescue Exception => e
        @query.transactions.create(
          url:      url,
          params:   @params_to_send,
          message:  { exception: e.message },
          status:   :error
        )
        return e.message
      end
    end
  end

private

  def get_places_from_blocks
    @query.blocks.map(&:data).flatten.select { |h| h.has_key?("place") }
  end

  def generate_params_to_send(object)
    {
      "facebook_id"         => @params[:facebook_user_id],
      "facebook_place[id]"  => object["place"]["id"]
    }
  end

  def url

  end

end