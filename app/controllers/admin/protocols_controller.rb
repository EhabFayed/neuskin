module Admin
  # Protocols CRUD. Copy, ordering, settings AND the structured plan data —
  # timeline stages, "why choose" points, patient story — are all edited
  # here. The page's FAQ comes from Faq placements (Admin → FAQ), not from
  # the protocol record (the old faqs JSONB column is kept but unused).
  # The structured parts are JSONB on the record; the form posts them as
  # indexed rows (protocol[stages][0][week_en] …) which #assign_structured
  # cleans into ordered arrays of hashes. Blocks render only when present,
  # so a protocol with no stages or FAQ is still safe to publish.
  class ProtocolsController < BaseController
    before_action :set_protocol, only: [ :edit, :update, :destroy ]

    STAGE_KEYS = %w[week_en week_ar title_en title_ar body_en body_ar].freeze
    STORY_KEYS = %w[quote_en quote_ar initials year].freeze
    WHY_KEYS   = %w[text_en text_ar].freeze
    SPEC_KEYS  = %w[label_en label_ar value_en value_ar].freeze

    def index
      @protocols = Protocol.all
    end

    def new
      @protocol = Protocol.new(position: Protocol.count + 1, persona: "unsure",
                               signs_en: I18n.t("protocol_page.signs", locale: :en).join("\n"),
                               signs_ar: I18n.t("protocol_page.signs", locale: :ar).join("\n"))
    end

    def create
      @protocol = Protocol.new(protocol_params)
      assign_structured
      if @protocol.save
        redirect_to admin_protocols_path, notice: "Protocol created."
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit; end

    def update
      @protocol.assign_attributes(protocol_params)
      assign_structured
      if @protocol.save
        @protocol.image.purge if params[:protocol][:remove_image] == "1" && params[:protocol][:image].blank?
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
        :meta_ar, :meta_en, :who_for_ar, :who_for_en, :signs_ar, :signs_en, :scope_ar, :scope_en,
        :excludes_ar, :excludes_en, :why_title_en, :why_title_ar,
        :position, :trademark, :persona, :codeword, :image,
        :meta_title_en, :meta_title_ar, :meta_description_en, :meta_description_ar
      )
    end

    # Timeline stages, FAQ rows and the patient story from the form. Each block
    # is only touched when its form section was submitted (the hidden
    # *_form flag), so API-style partial updates leave it alone.
    def assign_structured
      raw = params[:protocol]
      return if raw.blank?

      @protocol.stages = rows_from(raw[:stages], STAGE_KEYS) if raw[:stages_form].present?
      @protocol.why_points = rows_from(raw[:why_points], WHY_KEYS) if raw[:why_points_form].present?
      @protocol.specs = rows_from(raw[:specs], SPEC_KEYS) if raw[:specs_form].present?
      return if raw[:story_form].blank?

      story = (raw[:patient_story]&.to_unsafe_h || {}).slice(*STORY_KEYS).transform_values { |v| v.to_s.strip }
      @protocol.patient_story = story.values.all?(&:blank?) ? {} : story
    end

    # {"0" => {...}, "1" => {...}} → ordered array of clean hashes. Rows flagged
    # _destroy or left entirely blank are dropped; order follows the row's
    # position field, then its index.
    def rows_from(raw, keys)
      rows = raw.respond_to?(:to_unsafe_h) ? raw.to_unsafe_h : {}
      rows = rows.each_with_index.map { |(k, v), i| [ k, v, i ] } if rows.is_a?(Hash)
      Array(rows)
        .map { |k, v, i| [ v.to_h, (v.to_h["position"].presence || k).to_i, i ] }
        .reject { |v, _p, _i| v["_destroy"].to_s == "1" }
        .sort_by { |_v, p, i| [ p, i ] }
        .filter_map do |v, _p, _i|
          h = keys.index_with { |key| v[key].to_s.strip }
          h if h.values.any?(&:present?)
        end
    end
  end
end
