ActiveAdmin.register Comment, :as => 'Reviews' do

  menu priority: 5

  filter :book
  filter :rating

  scope('Unprocessed') { |review| review.where(status: :unprocessed) }
  scope('Approved') { |review| review.where(status: :approved) }
  scope('Rejected') { |review| review.where(status: :rejected) }

  index do
    render 'index', context: self
  end

  member_action :view, method: :get do
    @review = Comment.find(params[:id])
    respond_to do |format|
      format.js
    end
  end

  controller do

    before_action :set_review, only: :update

    def update
      @review.update(permitted_params)
      respond_to do |format|
        format.js
      end
    end

    def set_review
      @review = Comment.find(params[:id])
    end

    def permitted_params
      params.permit(:status)
    end
  end

end
