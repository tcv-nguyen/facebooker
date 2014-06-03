class PrettyClose

  attr_accessor :message, :query, :response
  attr_reader :message, :request, :params, :graph, :response_content, :data, :block_type

  def initialize(request, params)
    @request = request.fullpath
    @params = params
    build_query
  end

  def create_blocks(data)
    @page_number = 0
    begin
      @page_number += 1
      create_block(data)
    end while (data = data.next_page)
    @message = { success: "Create response blocks successfully." }
  end

  def steps
    [
      :build_graph,
      :update_query_status_to_processing,
      :initialize_graph,
      :create_query_response,
      :create_query_response_blocks,
      :update_query_response_status_to_processed,
      :update_query_status_to_processed
    ]
  end

  def build_query
    self.query = Query.new(url: @request, status: "new", params: @params)
    @message = 
      if query.valid?
        query.save
        { success: "Save query successfully." }
      else
        errors = query.errors.full_messages.join(". ")
        { error: errors }
      end
  end

  def build_graph
    @graph = ::Koala::Facebook::API.new(@params[:auth_token])
    @message = { success: "Koala Facebook initialized." }
  end

  def update_query_status_to_processing
    update_query(status: :processing, query_type: self.class.to_s)
  end

  def create_query_response
    @message = 
      if query_response = query.create_response(status: :processing)
        self.response = query_response
        { success: "Create query response successfully." }
      else
        { error: query_response.errors.full_messages.joins(". ") }
      end
  end

  def create_query_response_blocks
    create_blocks(@data)
  end

  def update_query_response_status_to_processed
    response.update_attributes(status: :processed)
  end

  def update_query_status_to_processed
    update_query(status: :processed)
  end

private

  def update_query(options = {})
    @message =
      if query.update_attributes(options)
        { success: "Update query successfully." }
      else
        { error: query.errors.full_messages.join(". ") }
      end
  end

  def create_block(data)
    status =
      if @page_number == 1
        "start"
      elsif has_next_page?(data)
        "continue"
      else
        "end"
      end
    response.blocks.create!(
      page_number: @page_number,
      status: status,
      block_type: @block_type,
      content: { data: data.to_json },
      next_page_params: { data: data.next_page_params.try(:to_json) },
      parent_id: @parent_id,
      parent_object: @parent_object
    )
  end

  def has_next_page?(data)
    data ? !data.next_page_params.blank? : false
  end

end