class PrettyClose::FacebookCheckinPages < PrettyClose

  def initialize_graph
    @data = @graph.fql_query("
      SELECT
        target_id
      FROM
        checkin
      WHERE
        author_uid = '#{@params[:facebook_user_id]}'
      AND
        target_type = 'page'
    ")
    @block_type = "checkin_pages"
    @message = { success: "Initialize Facebook Checkin Pages graph." }
  end

end