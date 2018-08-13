ActiveAdmin.register Book do
  menu priority: 1
  
  filter :category
  filter :books_authors_author_id, as: :select, collection: Author.all.map{ |author| ["#{author.first_name} #{author.last_name}", author.id] }, label: 'Author'
  filter :title
  filter :price

# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#
  permit_params :title, :description, :price, :publishing_year, :dimensions, :materials,
                :category_id, images: [], author_ids: []

  index do |books|
    selectable_column
    column :image
    column :category
    column :title
    column 'Authors' do |book|
      book.authors.map{ |author| "#{author.first_name} #{author.last_name}" }.join(', ')
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
      f.input :authors, collection: Author.all.map{ |author| ["#{author.first_name} #{author.last_name}", author.id] }
    end
    f.inputs
    f.actions
  end
  
#
# or
#
# permit_params do
#   permitted = [:permitted, :attributes]
#   permitted << :other if params[:action] == 'create' && current_user.admin?
#   permitted
# end
end
