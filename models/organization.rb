class Organization 

  attr_reader :memberships

  def children_organizations?
    if self.kind_of?(RootOrganization) && !self.parent_organizations.nil?
      self.parent_organizations.each do |parent|
        $memberships << Membership.new(@user, parent, @role)
      end
    elsif self.kind_of?(ParentOrganization) && !self.child_organizations.nil?
      self.child_organizations.each do |child|
        $memberships << Membership.new(@user, child, @role)
      end
    else
      nil
    end
  end

end