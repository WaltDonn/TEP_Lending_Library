class ComponentsController < ApplicationController
  before_action :set_component, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!
  
  # GET /components
  # GET /components.json
  def index
    @components = Component.all.paginate(:page => params[:page]).per_page(4)
    authorize! :index, :Components
  end

  # GET /components/1
  # GET /components/1.json
  def show
    authorize! :show, @component
  end

  # GET /components/new
  def new
    @component = Component.new
    authorize! :new, @component
  end

  # GET /components/1/edit
  def edit
    authorize! :edit, @component
  end

  # POST /components
  # POST /components.json
  def create
    @component = Component.new(component_params)
    authorize! :create, @component

    unless session[:item_id].nil?
      @component[:item_id] = session[:item_id]
    end

    if @component.damaged.nil?
      @component[:damaged] = 0
    end

    if @component.missing.nil?
      @component[:missing] = 0
    end

    respond_to do |format|
      if @component.save
        format.html { redirect_to @component, notice: 'Component was successfully created.' }
        format.json { render action: 'show', status: :created, location: @component }
        format.js
      else
        format.html { render :new }
        format.json { render json: @component.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /components/1
  # PATCH/PUT /components/1.json
  def update
    authorize! :update, @component
    respond_to do |format|
      if @component.update(component_params)
        format.html { redirect_to @component, notice: 'Component was successfully updated.' }
        # format.json { respond_with_bip(@component) }
        format.json { head :no_content }
        format.js
      else
        format.html { render :edit }
        format.json { respond_with_bip(@component) }
      end
    end
  end

  # DELETE /components/1
  # DELETE /components/1.json
  def destroy
    authorize! :destroy, @component
    @component.destroy
    respond_to do |format|
      @item = @component.item
      @components = @item.components
      format.html { redirect_to components_url, notice: 'Component was successfully destroyed.' }
      format.json { head :no_content }
      format.js
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_component
      @component = Component.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def component_params
      params.require(:component).permit(:max_quantity, :damaged, :missing, :consumable, :item_id, :name)
    end
end
