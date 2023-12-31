# app/controllers/menu_items_controller.rb

class MenuItemsController < ApplicationController
  before_action :set_menu_item, only: [:show, :edit, :update, :destroy]
  before_action :set_restaurant
  before_action :authenticate_user!, only: [:edit, :update, :destroy]
  before_action :check_ownership, only: [:edit, :update, :destroy]




  def new
    @menu_item = @restaurant.menu_items.build
  end

  def index
    @menu_items = @restaurant.menu_items
  end

  def create
    @menu_item = @restaurant.menu_items.build(menu_item_params)
    if @menu_item.save
      redirect_to @restaurant, notice: 'Menu item was successfully created.'
    else
      render :new
    end
  end

  def show
  end

  def edit
  end


  # PATCH/PUT /restaurants/:restaurant_id/menu_items/:id
  def update
    if @menu_item.update(menu_item_params)
      redirect_to restaurant_menu_items_path(@restaurant), notice: 'Menu item was successfully updated.'
    else
      flash.now[:alert] = @menu_item.errors.full_messages.to_sentence
      render :edit
    end
  end


  def destroy


    if @menu_item.destroy
      redirect_to restaurant_menu_items_path(@restaurant), notice: 'Menu item was successfully destroyed.'
    else
      redirect_to restaurant_menu_items_path(@restaurant), alert: 'Menu item could not be destroyed.'
    end
  end

  def customer_index
    @restaurant = Restaurant.find(params[:restaurant_id])

    @menu_items = @restaurant.menu_items
  end

  private

  def set_menu_item

    begin
      @menu_item = MenuItem.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      redirect_to home_path
      return
    end

  end


  def set_restaurant

    begin
      @restaurant = Restaurant.find(params[:restaurant_id]) if params[:restaurant_id].present?
      if current_user.present? && current_user.is_restaurant?
        @restaurant = current_user.restaurant
      end
    rescue ActiveRecord::RecordNotFound
      redirect_to home_path
      return
    end
  end

  def menu_item_params
    params.require(:menu_item).permit(:name, :description, :category, :spiciness, :price, :discount, :stock, :availability, :image)
  end

  private

def check_ownership
  unless current_user.is_restaurant? && @menu_item.restaurant.user == current_user
    redirect_to home_path, alert: "You are not authorized to perform this action."
  end
end

end
