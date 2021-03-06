class DiscountsController < ApplicationController
  def index
    # require "pry"; binding.pry
    @merchants = Merchant.all
    @merchant = Merchant.find(params[:merchant_id])
    # @merchant = Merchant.find(params[:id])
    @holidays = HolidayService.get_holidays
  end

  def show
    # require "pry"; binding.pry
    # @merchant = Merchant.find(:id)
    @merchant = Merchant.find(:merchant_id)
  end

  def new
    @discount = Discount.new
  end

  def create
    # require "pry"; binding.pry
    Merchant.find(params[:merchant_id]).discounts.create!(discount_params)
    redirect_to merchant_discounts_path(params[:merchant_id])
  end

  def destroy
    discount = Discount.find(params[:id])
    discount.destroy!
    redirect_to merchant_discounts_path(params[:merchant_id])
    # if discount.destroy!
    #   flash[:notice] = "Bulk discount has been removed!"
    #   redirect_to merchant_discounts_path(params[:merchant_id])
    # else
    #   flash[:notice] = "Unable to remove bulk discount!"
    #   render new_merchant_discount(params[:merchant_id])
    # end
  end

  private

  def discount_params
    #Why does this require not work, with error "undefined method `permit' for "18141":String"?
    # params.require(:merchant_id).permit(:percentage, :quantity)
    params.permit(:percentage, :quantity)
  end
end
