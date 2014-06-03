class PrettyClose::FacebookFriends < PrettyClose

  def initialize_graph
    @data = @graph.get_connections(@params[:facebook_user_id], "friends")
    @block_type = "friends"
    @message = { success: "Initialize Facebook Friends graph." }
  end

end