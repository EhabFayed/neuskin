module Admin
  # Device cards CRUD — the flip cards on /technologies. Mirrors
  # TreatmentsController; front_image is the product shot on the card front,
  # back_image the in-clinic photo on the spec (back) face.
  class DevicesController < BaseController
    before_action :set_device, only: [:edit, :update, :destroy]

    def index
      @devices = Device.all
    end

    def new
      @device = Device.new(position: Device.count + 1)
    end

    def create
      @device = Device.new(device_params)
      if @device.save
        redirect_to admin_devices_path, notice: "Device created."
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit; end

    def update
      if @device.update(device_params)
        redirect_to admin_devices_path, notice: "Device saved."
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @device.destroy
      redirect_to admin_devices_path, notice: "Device deleted."
    end

    private

    def set_device
      @device = Device.find(params[:id])
    end

    def device_params
      params.require(:device).permit(
        :name, :position, :front_image, :back_image,
        :tagline_en, :tagline_ar, :body_en, :body_ar, :specs_en, :specs_ar
      )
    end
  end
end
