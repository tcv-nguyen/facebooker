class PrettyClose::FacebookFriends < PrettyClose

  def initialize_graph
    @data = @graph.get_connections(@params[:facebook_user_id], "friends")
    @block_type = "friends"
    @message = { success: "Initialize Facebook Friends graph." }
  end

  def verify_params
    @message =
      if required_params.select{ |param| @params[param].blank? }.any?
        { error: "Invalid params." }
      else
        { success: "Params verified." }
      end
  end

private

  def required_params
    [:auth_token, :facebook_user_id]
  end

end