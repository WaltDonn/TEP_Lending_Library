class ItemsController < ApplicationController
  before_action :set_item, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!

  # GET /items
  # GET /items.json
  def index
    @status = params[:status]
    case params[:status]
      when 'Good'
        @items = Item.good.paginate(:page => params[:page]).per_page(10)
        @title = 'GOOD ITEMS'
      when 'Broken'
        @items = Item.broken.paginate(:page => params[:page]).per_page(10)
        @title = 'BROKEN ITEMS'
      when 'Available'
        @items = Item.available_for_kits.paginate(:page => params[:page]).per_page(10)
        @title = 'AVAILABLE FOR KITS'
      when 'Kits'
        @items = Item.has_kit.paginate(:page => params[:page]).per_page(10)
        @title = 'CURRENTLY USED'
      else 
         @items = Item.all.by_read_id.paginate(:page => params[:page]).per_page(10)
         @title = 'ALL ITEMS'
    end

    
     authorize! :index, :Items
  end

  # GET /items/1
  # GET /items/1.json
  def show
    authorize! :show, @item
  end

  # GET /items/new
  def new
    @item = Item.new
    authorize! :new, @item
  end

  # GET /items/1/edit
  def edit
    @component = Component.new
    
    if @item.kit.nil?
      @kit = Kit.new()
    else
      @kit = @item.kit
    end

    authorize! :edit, @item
  end
  
  
  def add_component
    # authorize! :new, @component
    @component.save!
  end
  
  # POST /items
  # POST /items.json
  def create
    @item = Item.new(item_params)
    authorize! :create, @item
    
    respond_to do |format|
      if @item.save
        format.html { redirect_to @item, notice: 'Item was successfully created.' }
        format.json { render :show, status: :created, location: @item }
      else
        format.html { render :new }
        format.json { render json: @item.errors, status: :unprocessable_entity }
      end
    end
  end
  
  # PATCH/PUT /items/1
  # PATCH/PUT /items/1.json
  def update

    authorize! :update, @item
    respond_to do |format|

    @item.item_category.name = params[:item][:item_category_attributes][:name]
    @item.item_category.description = params[:item][:item_category_attributes][:description]
    @item.item_category.item_photo = params[:item][:item_category_attributes][:item_photo]
    @kit = Kit.by_location(params[:item][:kit][:location]).first
    @item.kit = @kit
    
    if @item.update(item_params) && @item.item_category.save
        format.html { redirect_to @item, notice: 'Item was successfully updated.' }
        format.json { respond_with_bip(@item) }
      else
        format.html { render :show }
        format.json { respond_with_bip(@item) }
      end
    end
  end

  # DELETE /items/1
  # DELETE /items/1.json
  def destroy
    authorize! :destroy, @item
    @item.destroy
    respond_to do |format|
      format.html { redirect_to items_url, notice: 'Item was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_item
      @item = Item.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def item_params
      if params[:item][:condition] == "false"
        params[:item][:condition] = "Broken"
      elsif params[:item][:condition] == "true"
        params[:item][:condition] = "Good"
      end
        
      params.require(:item).permit(
        :readable_id, :condition, :kit_id, :item_category_id, :is_active,
        item_categoty_attributes: [:name, :description, :item_photo]
        )
    end
end
