ActiveAdmin.register Author do
  menu priority: 3
  
  permit_params :first_name, :last_name, :description
  index do
    selectable_column
    column :first_name
    column :last_name
    column :description
    actions
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
