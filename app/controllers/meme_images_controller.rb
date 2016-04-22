class MemeImagesController < ApplicationController
  before_filter :authorize_edit

  def manage
  end

  def search
    @images = MemeImage.all

    if params[:neutral_rating].to_i == 1
      @images = MemeImage.where(rating: 0)
    end

    @images = @images.order(:id)

    respond_to do |format|
      format.js
    end
  end

  def vote_up
    @image = MemeImage.find(params[:id])
    @image.rating += 1
    @image.save

    render json: @image.to_json
  end

  def vote_down
    @image = MemeImage.find(params[:id])
    @image.rating -= 1
    @image.save
    render json: @image.to_json
  end

  private

  def authorize_edit
    authorize! :update, MemeImage
  end
end
