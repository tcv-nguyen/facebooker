module Api
  class FacebookController < ApplicationController
    before_action :build_prettyclose_api

    def facebook_friends
      @api.process(:get_friends)
      render json: @api.message
    end

    def facebook_pages
      @api.process(:get_pages)
      render json: @api.message
    end

    def facebook_checkins
      @api.process(:get_checkins)
      render json: @api.message
    end

    def facebook_checkin_pages
      @api.process(:get_checkin_pages)
      render json: @api.message
    end

    def facebook_page_likes
      @api.process(:get_page_likes)
      render json: @api.message
    end

    def facebook_page_albums
      @api.process(:get_page_albums)
      render json: @api.message
    end

  private

    def build_prettyclose_api
      @api = PrettyClose.new(request, params)
    end

  end
end