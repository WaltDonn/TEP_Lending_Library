class KitsController < ApplicationController
  before_action :set_kit, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, except: [:steamkits, :available_kit]

  # GET /kits
  # GET /kits.json
  def index
    @kits = Kit.all.paginate(:page => params[:page]).per_page(10)
    authorize! :index, :Kits
  end
  
  def steamkits
    @rental_categories = Kit.rental_categories
  end
  
  def available_kit
    @rental_category = ItemCategory.find(params[:id])
    @kits_count = Kit.available_for_item_category(@rental_category).count
  end

  # GET /kits/1
  # GET /kits/1.json
  def show
     authorize! :show, @kit
  end

  # GET /kits/new
  def new
    @kit = Kit.new
    authorize! :new, @kit
    @item_category = ItemCategory.new
  end
  
  def create_item_category
    @item_category = ItemCategory.new
    authorize! :new, @item_category

    if(!params[:item_category][:item_photo].nil?)
      @user.item_photo = params[:user][:item_photo]
    end
    if(!params[:item_category][:name].nil?)
      @item_category.name = params[:item_category][:name]
    end
    if(!params[:item_category][:email].nil?)
      @item_category.email = params[:item_category][:email]
    end

    respond_to do |format|
      if @item_category.save
        if(!params[:item_category][:item_count].nil?)
          num = params[:item_category][:item_count]
          for i in 0..num
            @item = Item.new
            @item.item_category
          end
        end
      else
           format.html { render :new }
      end
    end
  end

  # GET /kits/1/edit
  def edit
    authorize! :edit, @kit
  end

  # POST /kits
  # POST /kits.json
  def create
    @kit = Kit.new(kit_params)
    authorize! :create, @kit

    respond_to do |format|
      if @kit.save
        format.html { redirect_to @kit, notice: 'Kit was successfully created.' }
        format.json { render :show, status: :created, location: @kit }
      else
        format.html { render :new }
        format.json { render json: @kit.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /kits/1
  # PATCH/PUT /kits/1.json
  def update
    authorize! :update, @kit
    respond_to do |format|
      if @kit.update(kit_params)
        format.html { redirect_to @kit, notice: 'Kit was successfully updated.' }
        format.json { render :show, status: :ok, location: @kit }
      else
        format.html { render :edit }
        format.json { render json: @kit.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /kits/1
  # DELETE /kits/1.json
  def destroy
    authorize! :destroy, @kit
    @kit.destroy
    respond_to do |format|
      format.html { redirect_to kits_url, notice: 'Kit was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_kit
      @kit = Kit.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def kit_params
      params.require(:kit).permit(:location, :is_active, :blackout)
    end
end
