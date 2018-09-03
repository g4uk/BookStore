ActiveAdmin.register Category do
  menu priority: 2

  permit_params :name
  index do
    selectable_column
    column :name
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
