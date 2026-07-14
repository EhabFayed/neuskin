module Admin
  # Protocols CRUD. Copy, ordering and settings are fully manageable here;
  # the structured plan data (stages, per-protocol FAQ, patient story jsonb)
  # renders only when present, so a newly created protocol is safe to publish
  # with copy alone and the structured blocks can follow later.
  class ProtocolsController < BaseController
    before_action :set_protocol, only: [:edit, :update, :destroy]

    def index
      @protocols = Protocol.all
    end

    def new
      @protocol = Protocol.new(position: Protocol.count + 1, persona: "unsure")
    end

    def create
      @protocol = Protocol.new(protocol_params)
      if @protocol.save
        redirect_to admin_protocols_path, notice: "Protocol created."
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit; end

    def update
      if @protocol.update(protocol_params)
        redirect_to admin_protocols_path, notice: "Protocol saved."
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @protocol.destroy
      redirect_to admin_protocols_path, notice: "Protocol deleted."
    end

    private

    def set_protocol
      @protocol = Protocol.find_by!(slug: params[:id])
    end

    def protocol_params
      params.require(:protocol).permit(
        :slug, :name_ar, :name_en, :promise_ar, :promise_en, :duration_ar, :duration_en,
        :meta_ar, :meta_en, :who_for_ar, :who_for_en, :scope_ar, :scope_en,
        :excludes_ar, :excludes_en, :position, :trademark, :persona, :codeword
      )
    end
  end
end
