# - We only want the last post from this query
# - Check if the last post is a new post if not disregard, could be done with validation ? 
#
class PrettyClose::FacebookPageNewsfeeds < PrettyClose

  def initialize_graph
    @data = @graph.get_connections(@params[:facebook_page_id], "feed?fields=id,name,link&limit=1").first
    @block_type = "feed"
    @message = {success: "Initialize Facebook Page Feeds."}
  end

  def verify_params
    return "Invalid params." if required_params.select{ |param| @params[param].blank? }.any?
  end
  
  def send_data_to_pretty_close
    @params_to_send = generate_params_to_send
    req = Net::HTTP.post_form(URI.parse(url),@params_to_send)
  end

  private
  def required_params
    [:auth_token, :facebook_page_id]
  end
  
  def generate_params_to_send
    {
      "facebook_page_id" => @params[:facebook_page_id],
      "facebook_post" => @data.to_json
    }
  end

  def url
    "#{prettyclose_server}/api/v1/internal/facebook_newsfeeds"
  end
end
