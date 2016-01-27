class Ability
  include CanCan::Ability

  def initialize(user)

    user ||= Usuario.new # guest user (not logged in)
    
    if user.es_admin?
         can :manage, :all
    elsif user.name != nil #user is signed_in?
        can [:show, :update], Usuario, :id => user.id 
        can [:read, :create], Negocio
        can [:update, :destroy], Negocio do |negocio|
            negocio.propietarios.map(&:id).include? user.id
        end
        can [:read, :update], Pedido, usuario_id: user.id
        can [:read,:update], Pedido do |pedido|
            pedido.negocio.propietarios.map(&:id).include? user.id 
        end
        can :read, Negocio
        can :manage, Direccion, :usuario_id => user.id
    else
        can :create, Usuario
        can :read, Negocio
    end


    # Define abilities for the passed in user here. For example:
    #
    #   user ||= User.new # guest user (not logged in)
    #   if user.admin?
    #     can :manage, :all
    #   else
    #     can :read, :all
    #   end
    #
    # The first argument to `can` is the action you are giving the user
    # permission to do.
    # If you pass :manage it will apply to every action. Other common actions
    # here are :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on.
    # If you pass :all it will apply to every resource. Otherwise pass a Ruby
    # class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the
    # objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details:
    # https://github.com/CanCanCommunity/cancancan/wiki/Defining-Abilities
  end
end
