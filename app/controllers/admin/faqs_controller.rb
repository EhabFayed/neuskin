module Admin
  # FAQ CRUD — dynamic counterpart of the old fixed-key faq/faq_items section.
  class FaqsController < BaseController
    before_action :set_faq, only: [:edit, :update, :destroy]

    def index
      @faqs = Faq.all.group_by { |f| f.category.to_s }
    end

    def new
      @faq = Faq.new(position: Faq.count + 1)
    end

    def create
      @faq = Faq.new(faq_params)
      if @faq.save
        redirect_to admin_faqs_path, notice: "Question added."
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit; end

    def update
      if @faq.update(faq_params)
        redirect_to admin_faqs_path, notice: "Question saved."
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @faq.destroy
      redirect_to admin_faqs_path, notice: "Question removed."
    end

    private

    def set_faq
      @faq = Faq.find(params[:id])
    end

    def faq_params
      params.require(:faq).permit(:question_ar, :question_en, :answer_ar, :answer_en,
                                  :category, :position)
    end
  end
end
