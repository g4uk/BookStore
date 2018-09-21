ActiveAdmin.register Book do
  menu priority: 1

  includes :images, :category, :books_authors, :authors

  filter :category
  filter :title
  filter :price

  permit_params :title, :description, :price, :publishing_year, :dimensions, :materials,
                :category_id, images: [], author_ids: [],
                images_attributes: [:id, :book_id, :photo]

  index do
    render 'index', context: self
  end

  controller do
    def create
      create! do |success, failure|
        success.html { redirect_to collection_url }
        failure.html { render :edit }
      end
    end

    def update
      update! do |success, failure|
        success.html { redirect_to collection_url }
        failure.html { render :edit }
      end
    end
  end

  form do |f|
    render partial: 'form', locals: { f: f }
  end
end
