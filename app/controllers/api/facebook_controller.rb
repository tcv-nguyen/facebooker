module Api
  class FacebookController < ApplicationController

    def process_query
      begin
        @api = "PrettyClose::#{params[:query].underscore.camelize}".constantize.new(request, params)
        @api.steps.each do |step|
          @api.send(step)
          @status, @message = *@api.message.flatten
          if @status == :error
            @message = "#{step}: #{@message}"
            break
          end
        end
      rescue Exception => e
        @api ||= PrettyClose.new(request, params)
        @status, @message = :error, e.message
      end
      create_query_log
      render json: { @status => @message }
    end

  private

    def create_query_log
      Log.create(query_id: @api.try(:query).try(:id), params: params, status: @status, message: @message)
    end

  end
end