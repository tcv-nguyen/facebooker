module Api
  class FacebookController < ApplicationController

    def process_query
      begin
        @pc = "PrettyClose::#{params[:query].underscore.camelize}".constantize.new(request, params)
        @pc.steps.each do |step|
          message = @pc.send(step)
          if message.class != String || message.blank?
            @pc.message = { success: step.to_s.titleize }
            @pc.create_query_log
          else
            @pc.message = { error: "#{step}@ #{message}" }
            @pc.create_query_log
            break
          end
        end
      rescue Exception => e
        @pc ||= PrettyClose.new(request, params)
        @pc.message = { error: "Unexpected Exception@ #{e.message} #{e.backtrace}" }
        @pc.create_query_log
      end
      render json: @pc.message
    end

  end
end
