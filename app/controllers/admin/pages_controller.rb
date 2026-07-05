module Admin
  class PagesController < BaseController
    def index
      @pages = SitePages::LIST
    end

    def show
      @slug     = params[:id]
      @name     = SitePages.name_for(@slug)
      @sections = Section.where(page: @slug).order(:position)
    end
  end
end
