module Admin
  # Promo codes CRUD — the digital gift cards at /promo and /promo/:code.
  # Mirrors FaqsController.
  class PromosController < BaseController
    before_action :set_promo, only: [ :edit, :update, :destroy ]

    def index
      @promos = Promo.all
    end

    def new
      @promo = Promo.new(position: Promo.count + 1, percent: 20)
    end

    def create
      @promo = Promo.new(promo_params)
      if @promo.save
        redirect_to admin_promos_path, notice: "Promo added."
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit; end

    def update
      if @promo.update(promo_params)
        redirect_to admin_promos_path, notice: "Promo saved."
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @promo.destroy
      redirect_to admin_promos_path, notice: "Promo removed."
    end

    private

    def set_promo
      @promo = Promo.find(params[:id])
    end

    def promo_params
      params.require(:promo).permit(:label_en, :label_ar, :percent, :code,
                                    :title_en, :title_ar, :description_en, :description_ar,
                                    :max_uses, :uses_count, :active, :position)
    end
  end
end
