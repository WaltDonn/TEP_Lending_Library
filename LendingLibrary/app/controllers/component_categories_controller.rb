class ComponentCategoriesController < ApplicationController
  before_action :set_component_category, only: [:show, :edit, :update, :destroy]

  # GET /component_categories
  # GET /component_categories.json
  def index
    @component_categories = ComponentCategory.all
  end

  # GET /component_categories/1
  # GET /component_categories/1.json
  def show
  end

  # GET /component_categories/new
  def new
    @component_category = ComponentCategory.new
  end

  # GET /component_categories/1/edit
  def edit
  end

  # POST /component_categories
  # POST /component_categories.json
  def create
    @component_category = ComponentCategory.new(component_category_params)

    respond_to do |format|
      if @component_category.save
        format.html { redirect_to @component_category, notice: 'Component category was successfully created.' }
        format.json { render :show, status: :created, location: @component_category }
      else
        format.html { render :new }
        format.json { render json: @component_category.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /component_categories/1
  # PATCH/PUT /component_categories/1.json
  def update
    respond_to do |format|
      if @component_category.update(component_category_params)
        format.html { redirect_to @component_category, notice: 'Component category was successfully updated.' }
        format.json { render :show, status: :ok, location: @component_category }
      else
        format.html { render :edit }
        format.json { render json: @component_category.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /component_categories/1
  # DELETE /component_categories/1.json
  def destroy
    @component_category.destroy
    respond_to do |format|
      format.html { redirect_to component_categories_url, notice: 'Component category was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_component_category
      @component_category = ComponentCategory.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def component_category_params
      params.require(:component_category).permit(:name, :description)
    end
end
