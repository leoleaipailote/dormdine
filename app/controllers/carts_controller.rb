class CartsController < ApplicationController
    before_action :set_cart, only: [:show, :clear_cart]

    def show
        @cart_items = @cart.cart_items.includes(:menu_item)
    end

    def clear_cart

        @cart.cart_items.destroy_all
        @cart.update(restaurant_id: nil)
        flash[:notice] = 'Cart has been cleared'
        if params[:restaurant_id]
            redirect_to customer_menu_path(restaurant_id: params[:restaurant_id]), notice: 'Successfully cleared cart'
        else
            redirect_to cart_path, notice: 'Successfully cleared cart'
        end

    end

    def back
        begin
            @cart = Cart.find(params[:cart_id])
        rescue ActiveRecord::RecordNotFound
            redirect_to home_path
            return
        end
        if @cart.restaurant_id.nil?
            redirect_to home_path
        else
            redirect_to customer_menu_path(restaurant_id: @cart.cart_items.sample.menu_item.restaurant_id)
        end
    end

    private

    def set_cart
        @cart = current_user.customer.cart
    end
  end
