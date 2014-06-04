module Api
  class FacebookController < ApplicationController

    def process_query
      begin
        @pc = "PrettyClose::#{params[:query].underscore.camelize}".constantize.new(request, params)
        @pc.steps.each do |step|
          @pc.send(step)
          if @pc.message.has_key?(:error)
            @pc.message = { error: "#{step}: #{@pc.message[:error]}" }
            break
          end
        end
      rescue Exception => e
        @pc ||= PrettyClose.new(request, params)
        @pc.message = { error: e.message }
      end
      @pc.create_query_log
      render json: @pc.message
    end

  end
end