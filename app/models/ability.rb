# frozen_string_literal: true

# See the wiki for details:
# https://github.com/CanCanCommunity/cancancan/wiki/Defining-Abilities

class Ability
  include CanCan::Ability

  attr_reader :user

  def initialize(user)
    @user = user

    if user
      user.admin? ? admin_abilities : user_abilities
    else
      guest_abilities
    end
  end

  def guest_abilities
    can :read, :all
  end

  def user_abilities
    guest_abilities
    can :create, [Question, Answer, Comment, Vote, Subscription]
    can :update, [Question, Answer], { user_id: user.id }
    can :destroy, [Question, Answer, Vote, Subscription], { user_id: user.id }
  end

  def admin_abilities
    can :manage, :all
  end
end
