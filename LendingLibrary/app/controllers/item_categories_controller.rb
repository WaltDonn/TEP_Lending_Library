class ItemCategoriesController < ApplicationController
  before_action :set_item_category, only: [:show, :edit, :update, :destroy]

  # GET /item_categories
  # GET /item_categories.json
  def index
    @item_categories = ItemCategory.all
  end

  # GET /item_categories/1
  # GET /item_categories/1.json
  def show
  end

  # GET /item_categories/new
  def new
    @item_category = ItemCategory.new
  end

  # GET /item_categories/1/edit
  def edit
  end

  # POST /item_categories
  # POST /item_categories.json
  def create
    @item_category = ItemCategory.new(item_category_params)

    respond_to do |format|
      if @item_category.save
        format.html { redirect_to @item_category, notice: 'Item category was successfully created.' }
        format.json { render :show, status: :created, location: @item_category }
      else
        format.html { render :new }
        format.json { render json: @item_category.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /item_categories/1
  # PATCH/PUT /item_categories/1.json
  def update
    respond_to do |format|
      if @item_category.update(item_category_params)
        format.html { redirect_to @item_category, notice: 'Item category was successfully updated.' }
        format.json { render :show, status: :ok, location: @item_category }
      else
        format.html { render :edit }
        format.json { render json: @item_category.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /item_categories/1
  # DELETE /item_categories/1.json
  def destroy
    @item_category.destroy
    respond_to do |format|
      format.html { redirect_to item_categories_url, notice: 'Item category was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_item_category
      @item_category = ItemCategory.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def item_category_params
      params.require(:item_category).permit(:name, :description, :item_photo, :inventory_level, :amount_available)
    end
end
