module Admin
  class SectionsController < BaseController
    before_action :set_section, only: [:show, :update, :preview]

    def show; end

    # Renders the REAL public page for this section, styled with the live site
    # CSS, but with the editor's UNSAVED values applied — shown in an iframe on
    # the edit screen. See app/views/layouts/preview.html.erb.
    PAGE_TEMPLATES = {
      "home"            => "pages/home",
      "dr_maysa"        => "pages/dr_maysa",
      "the_clinic"      => "pages/the_clinic",
      "maysa_method"    => "pages/neuskin_method",
      "the_team"        => "pages/the_team",
      "treatments"      => "pages/treatments",
      "private_care"    => "pages/private_care",
      "stories"         => "pages/stories",
      "faq"             => "pages/faq",
      "legal"           => "pages/legal",
      "protocols_index" => "protocols/index",
      "journal"         => "journal/index",
      "bridal"          => "bridal/show",
      "technologies"    => "pages/technologies",
    }.freeze

    def preview
      # Build an unsaved copy carrying the submitted (unsaved) values, keyed to
      # the same content records so each value maps to the right key.
      @__preview_section = @section
      assign_items
      @section.assign_attributes(section_params.except(:image))

      template = PAGE_TEMPLATES[@section.page]
      return head(:not_found) unless template

      prepare_page_vars(@section.page)
      render template: template, layout: "preview",
             locals: preview_locals(@section.page)
    end

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

    # Replicate the instance variables the public controllers set, so the
    # real page template renders correctly inside the preview.
    def prepare_page_vars(page)
      case page
      when "home"
        @sections = Section.where(page: "home").includes(:contents).index_by(&:kind)
      when "protocols_index"
        @protocols = Protocol.all
      when "bridal"
        @protocol = Protocol.find_by(slug: "brides-180")
        @lead = BridalLead.new
      when "journal"
        @blogs = Blog.published.newest_first.with_attached_image.includes(:contents)
      when "the_team"
        @members = TeamMember.with_attached_photo
      when "stories"
        @stories = Story.with_attached_photo
      when "faq"
        @faq_groups = Faq.grouped
      when "treatments"
        @treatments = Treatment.all
      when "technologies"
        @devices = Device.all
      end
    end

    def preview_locals(page)
      page == "legal" ? { doc: "privacy" } : {}
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
        :card_image_1, :card_image_2, :card_image_3,
        :card_image_4, :card_image_5, :card_image_6,
        gallery: [],
        settings: {},
        contents_attributes: [
          :id, :key, :label, :hint, :value_ar, :value_en,
          :content_type, :position, :_destroy
        ]
      )
    end
  end
end
