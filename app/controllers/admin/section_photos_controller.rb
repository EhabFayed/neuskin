module Admin
  # Delete one photo of a section album (The Clinic → "The Space"). Adding
  # and caption edits go through Admin::SectionsController#update.
  class SectionPhotosController < BaseController
    def destroy
      section = Section.find(params[:section_id])
      photo = section.photos.find(params[:id])
      photo.image.purge if photo.image.attached?
      photo.destroy
      redirect_to admin_section_path(section), notice: "Photo deleted."
    end

    def admin_nav = :pages
  end
end
