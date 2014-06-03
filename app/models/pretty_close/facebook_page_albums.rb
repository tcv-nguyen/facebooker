class PrettyClose::FacebookPageAlbums < PrettyClose

  def initialize_graph
    @data = @graph.get_connections(@params[:facebook_page_id], "albums")
    @block_type = "page_albums"
    @message = { success: "Initialize Facebook Page Albums graph." }
  end

  def create_query_response_blocks
    super
    blocks = response.blocks
    blocks.each do |block|
      albums = block.data
      albums.each_with_index do |album, index|
        @photo_data = @graph.get_connections(album["id"], "photos")
        @block_type = "photos"
        @parent_id = block.id
        # Using index to trace back data content
        @parent_object = { index: index }
        create_blocks(@photo_data)
      end
    end
  end

end