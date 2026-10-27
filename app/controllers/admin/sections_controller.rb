module Admin
  class SectionsController < BaseController
    before_action :set_section, only: [ :show, :update, :preview ]

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
      "protocol"        => "protocols/show",
      "journal"         => "journal/index",
      "bridal"          => "bridal/show",
      "technologies"    => "pages/technologies",
      "inquire"         => "inquiries/new"
    }.freeze

    def preview
      # Build an unsaved copy carrying the submitted (unsaved) values, keyed to
      # the same content records so each value maps to the right key.
      @__preview_section = @section
      assign_items
      # Caption edits on existing album photos preview live; a not-yet-saved
      # new photo (file upload) is left out of the preview.
      @section.assign_attributes(section_params.except(:image, :new_photo))

      template = PAGE_TEMPLATES[@section.page]
      return head(:not_found) unless template

      prepare_page_vars(@section.page)
      render template: template, layout: "preview",
             locals: preview_locals(@section.page)
    end

    def update
      # assign_items returns false (and records an error) on invalid JSON;
      # bail to a single render so we never double-render.
      if assign_items && valid_new_photo? && @section.update(section_params.except(:new_photo))
        purge_flagged_images
        attach_gallery_additions
        add_album_photo
        redirect_to admin_section_path(@section), notice: "Saved."
      else
        render :show, status: :unprocessable_entity
      end
    end

    private

    def set_section
      @section = Section.find(params[:id])
    end

    # "Add a photo" on an album section: one file plus its captions, appended
    # after the current photos. Captions typed without a file are an error
    # rather than silently dropped.
    def new_photo_params
      params.dig(:section, :new_photo) || {}
    end

    def valid_new_photo?
      np = new_photo_params
      return true if np[:image].present? || np.values_at(:caption_en, :caption_ar).all?(&:blank?)

      @section.errors.add(:base, "Choose an image file to add a photo (captions alone are not saved).")
      false
    end

    def add_album_photo
      np = new_photo_params
      return if np[:image].blank?

      next_position = (@section.photos.maximum(:position) || -1) + 1
      @section.photos.create!(image: np[:image], caption_en: np[:caption_en].to_s,
                              caption_ar: np[:caption_ar].to_s, position: next_position)
    end

    # "Add images" under a gallery appends to the current set (the plain
    # gallery field replaces it). Lets editors keep adding clinic photos
    # without re-uploading the ones already there (client audit, Oct 2026).
    def attach_gallery_additions
      files = Array(params.dig(:section, :gallery_add)).reject(&:blank?)
      @section.gallery.attach(files) if files.any?
    end

    # "Remove" in the image fields only sets section[remove_<slot>]=1; the
    # purge happens here after a successful save, and never when a
    # replacement file came in the same request.
    def purge_flagged_images
      slots = [ :image ] + (1..6).map { |i| :"card_image_#{i}" }
      slots.each do |slot|
        next unless params[:section]["remove_#{slot}"] == "1" && params[:section][slot].blank?
        att = @section.public_send(slot)
        att.purge if att.attached?
      end
    end

    # Replicate the instance variables the public controllers set, so the
    # real page template renders correctly inside the preview.
    def prepare_page_vars(page)
      case page
      when "home"
        @sections = Section.where(page: "home").includes(:contents).index_by(&:kind)
        @latest_posts = Blog.published.newest_first.with_attached_image.with_attached_image_ar
                            .includes(:contents).limit(3)
        @home_stories = Story.visible.highlighted.limit(3)
      when "protocols_index"
        @protocols = Protocol.all
      when "protocol"
        # The shared protocol copy previews on the first protocol; a stand-in
        # keeps the preview working on a database with no protocols yet.
        @protocol = Protocol.first || Protocol.new(slug: "preview", name_en: "A protocol", name_ar: "بروتوكول")
      when "bridal"
        @protocol = Protocol.find_by(slug: "brides-180")
        @lead = BridalLead.new
      when "journal"
        @blogs = Blog.published.newest_first.with_attached_image.with_attached_image_ar.includes(:contents)
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
      when "inquire"
        @inquiry = Inquiry.new
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
        ],
        photos_attributes: [ :id, :caption_en, :caption_ar, :position ],
        new_photo: [ :image, :caption_en, :caption_ar ]
      )
    end
  end
end
