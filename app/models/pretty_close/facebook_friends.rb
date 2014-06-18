class PrettyClose::FacebookFriends < PrettyClose

  def initialize_graph
    @block_type = "friends"
    @data = @graph.get_connections(@params[:facebook_user_id], "friends")
    debugger
    puts "jalla"
  end

  def required_params
    [:auth_token, :facebook_user_id]
  end

  def send_data_to_pretty_close
    @query.blocks.each do |block|
      block.data.each do |data|
        @object = graph_get_object(data["id"])
        next unless @object
        block.children.create!(
          response_id:  response.id,
          block_type:   "friend_profile",
          content:      { data: @object.to_json }
        )
        @params_to_send = generate_params_to_send(@object)
        begin
          req = Net::HTTP.post_form(URI.parse(url), @params_to_send)
          res = JSON.parse(req.body)
          @query.transactions.create!(
            url:      url,
            params:   @params_to_send,
            message:  res,
            status:   (res["success"].to_s == "true" ? :success : :error),
            block_id: block.id
          )
        rescue Exception => e
          @query.transactions.create(
            url:      url,
            params:   @params_to_send,
            message:  { exception: e.message },
            status:   :error,
            block_id: block.id
          )
          return e.message
        end
      end
    end
  end

private

  def url
    "#{prettyclose_server}/api/v1/internal/facebook_friends"
  end

  def generate_params_to_send(object)
    {
      "facebook_id"             => object["id"],
      "facebook_friend[name]"   => object["name"],
      "facebook_friend[email]"  => object["email"],
      "facebook_friend[city]"   => object["location"] ? object["location"]["name"] : ""
    }
  end

end
