class Api::V1::PinsController < ApplicationController
  before_action :check_token
  def index
    render json: Pin.all.order('created_at DESC')
  end

  def create
    pin = Pin.new(pin_params)
    if pin.save
      render json: pin, status: 201
    else
      render json: { errors: pin.errors }, status: 422
    end
  end

  private
    def pin_params
      params.require(:pin).permit(:title, :image_url)
    end

    def check_token
      user = User.find_by(email: request.headers['X-User-Email'])
      render status: 401 unless user &&
                                request.headers['X-Api-Token'] == user.api_token
    end
end