module Admin
  # Journal posts CRUD — mirrors the top_brand blogs admin, adapted to the
  # Studio admin (server-rendered forms, nested Content paragraphs).
  class BlogsController < BaseController
    before_action :set_blog, only: [:edit, :update, :destroy]

    def index
      @blogs = Blog.newest_first.includes(:contents).with_attached_image
    end

    def new
      @blog = Blog.new
      @blog.contents.build(key: "para_1", position: 1)
    end

    def create
      @blog = Blog.new(blog_params)
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
      assign_paragraph_keys
      if @blog.save
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
        contents_attributes: [:id, :key, :position, :value_ar, :value_en, :_destroy]
      )
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
