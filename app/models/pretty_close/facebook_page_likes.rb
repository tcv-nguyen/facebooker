class PrettyClose::FacebookPageLikes < PrettyClose

  def initialize_graph
    @data = @graph.fql_query("
      SELECT
        uid
      FROM
        page_fan
      WHERE
        uid IN (#{@params[:facebook_user_list]})
      AND
        page_id = '#{@params[:facebook_page_id]}'
    ")
    @block_type = "page_likes"
    @message = { success: "Initialize Facebook Page Likes graph." }
  end

end