# frozen_string_literal: true

ActiveAdmin.register Category do
  menu priority: 3

  filter :books
  filter :name

  permit_params :name

  config.clear_action_items!

  action_item only: :index do
    link_to t(:new_category), new_admin_category_path, remote: true
  end

  index do
    render 'index', context: self
  end

  controller do
    def new
      @category = Category.new
      respond_to do |format|
        format.js { render :edit }
      end
    end

    def create
      @category = Category.new(permitted_params)
      respond_to do |format|
        if @category.save
          format.js { flash[:notice] = t(:created) }
        else
          format.js { render :edit }
        end
      end
    end

    def edit
      @category = Category.find(params[:id])
      respond_to do |format|
        format.js
      end
    end

    def update
      @category = Category.find(params[:id])
      respond_to do |format|
        if @category.update(permitted_params)
          format.js { flash[:notice] = t(:edited) }
        else
          format.js { render :edit }
        end
      end
    end

    def permitted_params
      params.require(:category).permit(:name)
    end
  end
end
