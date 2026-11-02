module Admin
  # Treatments (outcomes) CRUD — the cards on /treatments and their sub-pages.
  # Mirrors ProtocolsController; the attached image drives both the card and
  # the sub-page hero, with a static per-slug asset as fallback.
  class TreatmentsController < BaseController
    before_action :set_treatment, only: [ :edit, :update, :destroy ]

    def index
      @treatments = Treatment.all
    end

    def new
      @treatment = Treatment.new(position: Treatment.count + 1).ensure_blocks!
    end

    def create
      @treatment = Treatment.new(treatment_params)
      if @treatment.save
        redirect_to admin_treatments_path, notice: "Treatment created."
      else
        @treatment.ensure_blocks!
        render :new, status: :unprocessable_entity
      end
    end

    # Page-section rows are created on demand so every registry field shows.
    def edit
      @treatment.ensure_blocks!
    end

    def update
      if @treatment.update(treatment_params)
        @treatment.image.purge if params[:treatment][:remove_image] == "1" && params[:treatment][:image].blank?
        redirect_to admin_treatments_path, notice: "Treatment saved."
      else
        @treatment.ensure_blocks!
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
        :slug, :position, :protocol_slug, :image, :hidden,
        :title_en, :title_ar, :headline_en, :headline_ar,
        :look_en, :look_ar, :how_en, :how_ar, :view_en, :view_ar,
        :meta_title_en, :meta_title_ar, :meta_description_en, :meta_description_ar,
        contents_attributes: [ :id, :key, :value_ar, :value_en ]
      )
    end
  end
end
