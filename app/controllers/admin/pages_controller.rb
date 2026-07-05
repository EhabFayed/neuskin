module Admin
  class PagesController < BaseController
    def index
      # Section counts + most-recent edit per page, for the Pages table.
      grouped = Section.group(:page).count
      edited  = Section.group(:page).maximum(:updated_at)
      @pages = SitePages::LIST.map do |p|
        {
          slug:        p[:slug],
          name:        p[:name],
          sections:    grouped[p[:slug]].to_i,
          last_edited: edited[p[:slug]]
        }
      end
    end

    def show
      @slug     = params[:id]
      @name     = SitePages.name_for(@slug)
      @sections = Section.where(page: @slug).order(:position)
    end
  end
end
