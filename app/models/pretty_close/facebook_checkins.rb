class PrettyClose::FacebookCheckins < PrettyClose

  def initialize_graph
    @data = @graph.get_connections(@params[:facebook_page_id], "checkins")
    @block_type = "checkins"
    @message = { success: "Initialize Facebook Checkins graph." }
  end

end