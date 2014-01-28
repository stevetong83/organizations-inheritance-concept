class Membership 

  attr_reader :user, :organization, :role, :memberships

  $memberships = []

  def initialize user, organization, role
    @user = user
    @organization = organization
    @role = role
    @organization.children_organizations? @user, @role
  end
end