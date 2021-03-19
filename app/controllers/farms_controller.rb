class FarmsController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[show index listFarms]

  def index
    @navbar = false
    if params[:address].present?
      coords = Geocoder.coordinates(params[:address])
      categories = params.keys
      @farms = Farm.tagged_with(categories, any: true).near(params[:address], 100)
    else
      coords = Geocoder.coordinates('Lyon')
      @farms = Farm.near('Lyon', 100)
    end
    @querys = params.keys
    @address = params[:address]

    @markers = {
      type: 'FeatureCollection',
      coordinates: coords,
      features: []
      }
    @farms.each do |farm|
      reviews = Review.select { |m| m.farm == farm }
      rating = Review.where(farm: farm).average(:rating).to_i
      @markers[:features] << {
        type: "Feature",
        geometry: {
          type: "Point",
          coordinates: farm.coordinates
        },
        properties: {
          id: farm.id,
          address: farm.address,
          infoWindow: render_to_string(
            partial: "info_window",
            locals: { farm: farm, reviews: reviews, rating: rating }
          )
        }
      }
    end
  end

  def listFarms
    @address = params[:address]
    coords = Geocoder.coordinates(@address)
    categories = params.keys

    @farms = Farm.tagged_with(categories, any: true).near(@address, 100)
    @querys = { fleurs: 'on' }
    @farms.each do |farm|
      @reviews = Review.select { |m| m.farm == farm }
      @rating = Review.where(farm: farm).average(:rating).to_i
    end
    #@querys = categories
  end

  def show
    @farm = Farm.find(params[:id])
    @reviews = Review.select { |m| m.farm == @farm }
    @rating = Review.where(farm: @farm).average(:rating).to_i

  end

  def new
    @farm = Farm.new
  end

  def create
    @farm = Farm.new(farm_params)
    if @farm.save
      redirect_to farm_path(@farm)
    else
      render :new
    end
  end

  private

  def find_farm
    @farm = Farm.find(params[:id])
  end

  def farm_params
    params.require(:farm).permit(:name, :user_id, :content, :email, :tel, :address, :category, :tag_list, photos: [])
  end
end
