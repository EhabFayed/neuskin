class ProtocolsController < ApplicationController
  def index
    @protocols = Protocol.all
  end

  def show
    @protocol = Protocol.find_by!(slug: params[:id])
  end
end
