include ActiveAdminHelpers
ActiveAdmin.register Book do
  menu priority: 1

  filter :category
  filter :books_authors_author_id#, as: :select, collection: authors_with_ids, label: 'Author'
  filter :title
  filter :price

  permit_params :title, :description, :price, :publishing_year, :dimensions, :materials,
                :category_id, images: [], author_ids: []

  index do |books|
    selectable_column
    column 'Images' do |book|
      image_tag book.try(:images).first.variant(resize: '100x100') unless book.images.blank?
    end
    column :category
    column :title
    column 'Authors' do |book|
      authors_links(book.authors)
    end
    column :description
    column :price do |book|
      number_to_currency book.price
    end
    actions
  end

  form do |f|
    f.semantic_errors
    f.inputs 'Authors' do
      f.input :authors, as: :check_boxes, collection: authors_with_ids
    end
    f.inputs
    f.inputs 'Images' do
      f.input :images, as: :file, input_html: { multiple: true }
    end
    f.actions
  end
end
