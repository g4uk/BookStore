class Ability
  include CanCan::Ability

  def initialize(user)
    if user.present?
      if user.has_role? :customer
        can %i[index show update], Order, user_id: user.id
        can :manage, CreditCard, user_id: user.id
        can :manage, Address, user_id: user.id
        can :manage, User, id: user.id
        can :manage, Comment
      end
      can :manage, :all if user.has_role? :admin
    end
  end
end
