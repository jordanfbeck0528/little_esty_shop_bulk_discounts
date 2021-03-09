class Admin::InvoicesController < ApplicationController
  before_action :set_invoice, only: [:show, :edit, :update]
  def index
    @invoices = Invoice.all
  end

  def show
  end

  def edit
  end

  def update
    if @invoice.update(invoice_params)
      flash.notice = 'Invoice Has Been Updated!'
      redirect_to admin_invoice_path(@invoice)
    else
      flash.notice = "All fields must be completed, please try again."
      render :edit
    end
  end

  private
  def set_invoice
    @invoice = Invoice.find(params[:id])
  end

  def invoice_params
    params.require(:invoice).permit(:status)
  end
end
