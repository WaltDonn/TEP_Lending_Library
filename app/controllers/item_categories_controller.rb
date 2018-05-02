class ItemCategoriesController < ApplicationController
  before_action :set_item_category, only: [:edit, :update, :destroy]

  def new
    @item_category = ItemCategory.new
  end

  def edit
  end

  def create
    @item_category = ItemCategory.new(item_category_params)

    respond_to do |format|
      if @item_category.save

        x = params[:item_category][:item_count].to_i
        if x < 0
          x = 0
        end
        x.times do |i|
            @item = Item.new()
            @item.item_category = @item_category
            @item.condition = "Good"
            @item.readable_id = "#{@item_category.name}" + i.to_s
            @item.save
        end

        format.html { redirect_to items_path, notice: 'Item Category was successfully created.' }
        format.js
      else
        format.html { render :new }
        format.json { render json: @item_category.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @item_category.update(item_category_params)
        format.html { redirect_to item_path(params[:item_category][:item_id]), notice: 'Category was successfully updated.' }
        format.json { respond_with_bip(@item_category) }
        format.js
      else
        format.html { render :edit }
        format.json { respond_with_bip(@item_category) }
      end
    end
  end

  def destroy
    authorize! :destroy, @item_category
    @item_category.destroy
    respond_to do |format|
      format.html { redirect_to item_categorys_url, notice: 'Category was successfully destroyed.' }
      format.js
    end
  end
    
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_item_category
      @item_category = ItemCategory.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def item_category_params
      params.require(:item_category).permit(:name, :description, :item_photo)
    end
end
