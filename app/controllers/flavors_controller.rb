class FlavorsController < ApplicationController
  before_action :set_flavor, only: [:show, :edit, :update, :destroy]

  # GET /flavors
  # GET /flavors.json
  def index
    @active_flavors = Flavor.active.alphabetical.paginate(page: params[:page]).per_page(10)
    @inactive_flavors = Flavor.inactive.alphabetical.paginate(page: params[:page]).per_page(10)
  end

  # GET /flavors/1
  # GET /flavors/1.json
  def show
  end

  # GET /flavors/new
  def new
    @flavor = Flavor.new
  end

  # GET /flavors/1/edit
  def edit
  end

  # POST /flavors
  # POST /flavors.json
  def create
    @flavor = Flavor.new(flavor_params)

    respond_to do |format|
      if @flavor.save
        format.html { redirect_to @flavor, notice: "Flavor #{@flavor.name} was successfully created." }
        format.json { render :show, status: :created, location: @flavor }
      else
        format.html { render :new }
        format.json { render json: @flavor.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /flavors/1
  # PATCH/PUT /flavors/1.json
  def update
    respond_to do |format|
      if @flavor.update(flavor_params)
        format.html { redirect_to @flavor, notice: "Flavor #{@flavor.name} was successfully updated." }
        format.json { render :show, status: :ok, location: @flavor }
      else
        format.html { render :edit }
        format.json { render json: @flavor.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /flavors/1
  # DELETE /flavors/1.json
  def destroy
    @flavor.destroy
    respond_to do |format|
      format.html { redirect_to flavors_url, notice: "Flavor #{@flavor.name} was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_flavor
      @flavor = Flavor.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def flavor_params
      params.require(:flavor).permit(:name, :active)
    end
end
