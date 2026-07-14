module Admin
  # Patient stories CRUD — dynamic counterpart of the old fixed-key
  # stories/story_items section.
  class StoriesController < BaseController
    before_action :set_story, only: [:edit, :update, :destroy]

    def index
      @stories = Story.with_attached_photo
    end

    def new
      @story = Story.new(position: Story.count + 1)
    end

    def create
      @story = Story.new(story_params)
      if @story.save
        redirect_to admin_stories_path, notice: "Story added."
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit; end

    def update
      if @story.update(story_params)
        @story.photo.purge if params[:story][:remove_photo] == "1"
        redirect_to admin_stories_path, notice: "Story saved."
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @story.destroy
      redirect_to admin_stories_path, notice: "Story removed."
    end

    private

    def set_story
      @story = Story.find(params[:id])
    end

    def story_params
      params.require(:story).permit(
        :intro_ar, :intro_en, :quote_ar, :quote_en, :protocol_line_ar, :protocol_line_en,
        :close_ar, :close_en, :byline_ar, :byline_en, :position, :photo
      )
    end
  end
end
