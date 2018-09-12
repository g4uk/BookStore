ActiveAdmin.register Author do
  menu priority: 2

  filter :last_name

  permit_params :first_name, :last_name, :description

  config.clear_action_items!

  action_item only: :index do
    link_to t(:new_author), new_admin_author_path, remote: true
  end

  index do
    render 'index', context: self
  end

  controller do
    def new
      @author = Author.new
      respond_to do |format|
        format.js { render :edit }
      end
    end

    def create
      @author = Author.new(permitted_params)
      @authors = Author.all
      respond_to do |format|
        if @author.save
          format.js { flash[:notice] = t(:created) }
        else
          format.js { render :edit }
        end
      end
    end

    def edit
      @author = Author.find(params[:id])
      respond_to do |format|
        format.js
      end
    end

    def update
      @author = Author.find(params[:id])
      respond_to do |format|
        if @author.update(permitted_params)
          format.js { flash[:notice] = t(:edited) }
        else
          format.js { render :edit }
        end
      end
    end

    def permitted_params
      params.require(:author).permit(:first_name, :last_name, :description)
    end
  end
end
