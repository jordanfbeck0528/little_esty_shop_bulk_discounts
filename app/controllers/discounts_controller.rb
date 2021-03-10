class DiscountsController < ApplicationController
  def index

    @merchants = Merchant.all
    @merchant = Merchant.find(params[:merchant_id])
    @holidays = HolidayService.get_holidays
  end

  def show
    @merchant = Merchant.find(params[:merchant_id])
    @discount = Discount.find(params[:id])
  end

  def new
    @discount = Discount.new
  end

  def create
    discount = Merchant.find(params[:merchant_id]).discounts.new(discount_params)
# require "pry"; binding.pry
    if discount.save
      flash[:notice] = "Bulk discount has been created!"
      redirect_to merchant_discounts_path(params[:merchant_id])
    else
      flash[:notice] = "All fields must be completed, please try again."
      # render :new
      redirect_to new_merchant_discount_path(params[:merchant_id])
    end
  end

  def destroy
    merchant = Merchant.find(params[:merchant_id])
    discount = Discount.find(params[:id])
    discount.destroy!
    if discount.destroy!
      flash[:notice] = "Bulk discount has been removed!"
      redirect_to merchant_discounts_path(params[:merchant_id])
    end
  end

  def edit
    @merchant = Merchant.find(params[:merchant_id])
    @discount = Discount.find(params[:id])
  end

  def update
    @discount = Discount.find(params[:id])
    @discount.update(discount_params)

    redirect_to merchant_discount_path(params[:merchant_id], @discount)
  end

  private

  def discount_params
    params.permit(:percentage, :quantity)
  end
end
