class MemeImagesController < ApplicationController
  before_filter :authorize_edit

  def manage
    @images = MemeImage.all.order(:id)
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
