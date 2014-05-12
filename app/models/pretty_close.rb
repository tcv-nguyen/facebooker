class PrettyClose

  attr_accessor :query, :response
  attr_reader :message, :request, :params, :graph, :response_content

  def initialize(request, params)
    @request = request.fullpath
    @params = params
    @message = {}
    build_graph
    build_query
  end

  def process(type)
    @type = type
    begin
      update_query(status: :processing, query_type: @type)
      send(@type)
      update_query(status: :processed)
    rescue Exception => e
      message = e.message
      create_log(message)
      @message = { error: message }
    end
  end

  def get_friends
    @data = @graph.get_connections(@params[:facebook_user_id], "friends")
    @block_type = "friends"
    create_response_and_blocks
  end

  def get_pages
    @data = @graph.get_connections("search", "?type=page&q=#{@params[:search_term]}")
    @block_type = "search"
    create_response_and_blocks
  end

  def get_checkins
    @data = @graph.get_connections(@params[:facebook_page_id], "checkins")
    @block_type = "checkins"
    create_response_and_blocks
  end

  def get_checkin_pages
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
    create_response_and_blocks
  end

  def get_page_likes
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
    create_response_and_blocks
  end

  def get_page_albums
    @data = @graph.get_connections(@params[:facebook_page_id], "albums")
    @block_type = "page_albums"
    # Get all albums
    create_response_and_blocks
    # Process each block to get photo for each album
    blocks = response.blocks
    blocks.each do |block|
      albums = block.data
      albums.each_with_index do |album, index|
        @data = @graph.get_connections(album["id"], "photos")
        @block_type = "photos"
        @parent_id = block.id
        # Using index to trace back data content
        @parent_object = { index: index }
        create_blocks
      end
    end
  end

private

  def build_graph
    @graph = ::Koala::Facebook::API.new(@params[:auth_token])
  end

  def build_query
    self.query = Query.new(url: @request, status: "new", params: @params)
    if query.valid?
      query.save
    else
      errors = query.errors.full_messages.join(". ")
      @message = errors
      create_log(errors)
    end
  end

  def update_query(options = {})
    query.update_attributes(options)
  end

  def update_response(options = {})
    response.update_attributes(options)
  end

  def create_response_and_blocks
    create_query_response(status: :processing)
    create_blocks
    update_response(status: :processed)
  end

  def create_query_response(options = {})
    self.response = query.create_response!(options)
  end

  def create_blocks
    @page_number = 0
    begin
      @page_number += 1
      create_block
    end while (@data = @data.next_page)
  end

  def create_block
    status =
      if @page_number == 1
        "start"
      elsif has_next_page?
        "continue"
      else
        "end"
      end
    response.blocks.create!(
      page_number: @page_number,
      status: status,
      block_type: @block_type,
      content: { data: @data.to_json },
      next_page_params: { data: @data.next_page_params.try(:to_json) },
      parent_id: @parent_id,
      parent_object: @parent_object
    )
  end

  def create_log(message)
    Log.create(query_id: query.id, params: @params, message: message)
  end

  def has_next_page?
    @data ? !@data.next_page_params.blank? : false
  end

end