module Admin
  # Treatments (outcomes) CRUD — the cards on /treatments and their sub-pages.
  # Mirrors ProtocolsController; the attached image drives both the card and
  # the sub-page hero, with a static per-slug asset as fallback.
  class TreatmentsController < BaseController
    before_action :set_treatment, only: [:edit, :update, :destroy]

    def index
      @treatments = Treatment.all
    end

    def new
      @treatment = Treatment.new(position: Treatment.count + 1)
    end

    def create
      @treatment = Treatment.new(treatment_params)
      if @treatment.save
        redirect_to admin_treatments_path, notice: "Treatment created."
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit; end

    def update
      if @treatment.update(treatment_params)
        redirect_to admin_treatments_path, notice: "Treatment saved."
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @treatment.destroy
      redirect_to admin_treatments_path, notice: "Treatment deleted."
    end

    private

    def set_treatment
      @treatment = Treatment.find_by!(slug: params[:id])
    end

    def treatment_params
      params.require(:treatment).permit(
        :slug, :position, :protocol_slug, :image,
        :title_en, :title_ar, :headline_en, :headline_ar,
        :look_en, :look_ar, :how_en, :how_ar, :view_en, :view_ar
      )
    end
  end
end
