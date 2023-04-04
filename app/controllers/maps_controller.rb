class MapsController < ApplicationController
  def index
    @map = Map.all
  end

  def popup
    @popup = Map.where(id: params[:id]).to_a
  end
end
