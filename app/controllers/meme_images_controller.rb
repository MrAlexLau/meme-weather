class MemeImagesController < ApplicationController
  before_filter :authorize_edit

  def manage
  end

  def vote
  end

  def fetch_images
    @num_images_selection = []

    [10, 50, 100].each do |num|
      @num_images_selection << [num, num]
    end
  end

  def fetch_more
    tag_list = params[:tag_list].split(" ")
    tag_list << 'meme' unless tag_list.include?('meme')

    num_images = (params[:num_images] || 10).to_i

    i = 1
    while i <= num_images
      MemeQuery.create_by_tags(tag_list, { start_index: i })
      i += 10
    end

    @images = MemeQuery.tagged_memes(tag_list)
    @hide_voting = true

    render 'search', :format => :js
  end

  def search
    @images = searched_images
    @hide_voting = (params[:hide_voting].to_i == 1)

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

  def searched_images
    images = MemeImage.all

    if params[:neutral_rating].to_i == 1
      images = MemeImage.where(rating: 0)
    end

    if params[:tag_list]
      tags = params[:tag_list].split(" ")
      images = images.tagged_with(tags)
    end

    images.order(:id)
  end
end
