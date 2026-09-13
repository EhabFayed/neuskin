module Admin
  # Journal posts CRUD — mirrors the top_brand blogs admin, adapted to the
  # Studio admin (server-rendered forms, nested Content paragraphs).
  class BlogsController < BaseController
    before_action :set_blog, only: [ :edit, :update, :destroy ]

    def index
      @blogs = Blog.newest_first.includes(:contents).with_attached_image
    end

    def new
      @blog = Blog.new
      @blog.contents.build(key: "para_1", position: 1)
    end

    def create
      @blog = Blog.new(blog_params)
      @blog.faqs = normalized_faqs if faqs_submitted?
      assign_paragraph_keys
      if @blog.save
        redirect_to edit_admin_blog_path(@blog), notice: "Post created."
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit; end

    def update
      @blog.assign_attributes(blog_params)
      @blog.faqs = normalized_faqs if faqs_submitted?
      assign_paragraph_keys
      if @blog.save
        @blog.image.purge if params[:blog][:remove_image] == "1"
        purge_flagged_paragraph_photos
        redirect_to edit_admin_blog_path(@blog), notice: "Post saved."
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @blog.destroy
      redirect_to admin_blogs_path, notice: "Post deleted."
    end

    private

    def set_blog
      @blog = Blog.find_by_any_slug!(params[:id])
    end

    def blog_params
      params.require(:blog).permit(
        :slug_en, :slug_ar, :title_ar, :title_en, :excerpt_ar, :excerpt_en,
        :meta_title_ar, :meta_title_en, :meta_description_ar, :meta_description_en,
        :alt_ar, :alt_en, :category, :is_published, :image,
        contents_attributes: [ :id, :key, :position, :value_ar, :value_en,
                              :photo, :alt_ar, :alt_en, :remove_photo, :_destroy ]
      )
    end

    FAQ_KEYS = %w[q_en q_ar a_en a_ar].freeze

    # The form always posts a marker, so an emptied list still clears faqs;
    # API-style requests without either key leave faqs untouched.
    def faqs_submitted?
      params[:blog].key?(:faqs) || params[:blog][:faqs_submitted].present?
    end

    # FAQ rows arrive as blog[faqs][][q_en] etc. (an array of hashes). Keep
    # only the four known keys, strip whitespace, and drop rows that are
    # entirely blank (the "+ Add question" template leaves empty rows behind).
    def normalized_faqs
      rows = params[:blog][:faqs]
      rows = rows.values if rows.respond_to?(:values) && !rows.is_a?(Array)
      Array(rows).filter_map do |row|
        next unless row.respond_to?(:to_unsafe_h) || row.is_a?(Hash)

        h = (row.respond_to?(:to_unsafe_h) ? row.to_unsafe_h : row).slice(*FAQ_KEYS)
        h = FAQ_KEYS.index_with { |k| h[k].to_s.strip }
        h if h.values.any?(&:present?)
      end
    end

    # "Remove image" checkboxes set a virtual flag on the in-memory contents;
    # purge after save (virtual attrs don't dirty the record, so a model
    # callback would never fire).
    def purge_flagged_paragraph_photos
      @blog.contents.each do |content|
        content.photo.purge if content.remove_photo.in?([ "1", true ]) && content.photo.attached?
      end
    end

    # Paragraph rows arrive without stable keys (the form only orders them);
    # Content requires a key, so derive one from position.
    def assign_paragraph_keys
      @blog.contents.each_with_index do |content, i|
        content.position = i + 1 if content.position.blank? || content.position.zero?
        content.key = "para_#{content.position}" if content.key.blank?
        content.content_type ||= "text"
      end
    end
  end
end
