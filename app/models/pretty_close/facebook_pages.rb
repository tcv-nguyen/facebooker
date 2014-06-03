class PrettyClose::FacebookPages < PrettyClose

  def initialize_graph
    @data = @graph.get_connections("search", "?type=page&q=#{@params[:search_term]}")
    @block_type = "search"
    @message = { success: "Initialize Facebook Search Pages graph." }
  end

end