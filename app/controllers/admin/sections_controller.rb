module Admin
  class SectionsController < BaseController
    before_action :set_section, only: [:show, :update]

    def show; end

    def update
      # assign_items returns false (and records an error) on invalid JSON;
      # bail to a single render so we never double-render.
      if assign_items && @section.update(section_params)
        redirect_to admin_section_path(@section), notice: "Saved."
      else
        render :show, status: :unprocessable_entity
      end
    end

    private

    def set_section
      @section = Section.find(params[:id])
    end

    # `items` is edited as a JSON text field for now (repeating-group UI is a
    # later refinement). Parse it into the JSONB column. Returns true on
    # success (or when no items_json was submitted); on invalid JSON it records
    # an error and returns false so #update renders the form exactly once.
    def assign_items
      raw = params.dig(:section, :items_json)
      return true if raw.nil?

      @section.items = raw.blank? ? [] : JSON.parse(raw)
      true
    rescue JSON::ParserError
      @section.errors.add(:base, "Items JSON is invalid.")
      false
    end

    def section_params
      params.require(:section).permit(
        :label, :image,
        settings: {},
        contents_attributes: [
          :id, :key, :label, :hint, :value_ar, :value_en,
          :content_type, :position, :_destroy
        ]
      )
    end
  end
end
