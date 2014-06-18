require "net/http"

class PrettyClose

  attr_accessor :message, :query, :response
  attr_reader :message, :request, :params, :graph, :response_content, :data, :block_type

  def initialize(request, params)
    @request = request.fullpath
    @params = params
    build_query
  end

  def build_query
    self.query = Query.new(url: @request, status: "new", params: @params)
    query.save!
  end

  def create_query_log
    status, message = *@message.flatten
    Log.create(query_id: query.try(:id), params: @params, status: status, message: message)
  end

  def create_blocks(data)
    @page_number = 0
    begin
      @page_number += 1
      create_block(data)
    end while ((data.respond_to?(:next_page) ? data = data.next_page : false))
  end

  def steps
    [
      :verify_params,
      :build_graph,
      :update_query_status_to_processing,
      :initialize_graph,
      :create_query_response,
      :create_query_response_blocks,
      :update_query_response_status_to_processed,
      :update_query_status_to_processed,
      :send_data_to_pretty_close
    ]
  end

  def verify_params
    return "Invalid params." if required_params.select{ |param| @params[param].blank? }.any?
  end

  def build_graph
    @graph = ::Koala::Facebook::API.new(@params[:auth_token])
  end

  def update_query_status_to_processing
    update_query(status: :processing, query_type: self.class.to_s)
  end

  def initialize_graph
    "need to be defined in its class."
  end

  def create_query_response
    self.response = query.create_response!(status: :processing)
  end

  def create_query_response_blocks
    create_blocks(@data)
  end

  def update_query_response_status_to_processed
    response.update_attributes!(status: :processed)
  end

  def update_query_status_to_processed
    update_query(status: :processed)
  end

  def send_data_to_pretty_close
    "need to be defined in its class."
  end

  def graph_get_object(id)
    begin
      @graph.get_object(id)
    rescue Exception => e
      @query.logs.create!(
        params: id,
        status: :error,
        message: e.message
      )
      nil
    end
  end

protected

  def prettyclose_server
    APP_CONFIG["prettyclose_server"]
  end

private

  def update_query(options = {})
    query.update_attributes!(options)
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
      next_page_params: { data: has_next_page?(data) ? data.next_page_params.try(:to_json) : '' },
      parent_id: @parent_id,
      parent_object: @parent_object
    )
  end

  def has_next_page?(data)
    return false unless data.respond_to?(:next_page)
    data ? !data.next_page_params.blank? : false
  end

end
