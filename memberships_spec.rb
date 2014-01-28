require './models/organization'
require './models/root_organization'
require './models/parent_organization'
require './models/child_organization'
require './models/user'
require './models/membership'
require 'pry'
 
describe Membership do
  let(:user) {double(User)}
  let(:org) {}
  let(:role) {"Admin"}
  before {$memberships = []}

  describe "root organization" do
    let(:org) {RootOrganization.new}

    context "when there is only a root organization" do
      before {$memberships << Membership.new(user, org, role)}

      it "should create one memberships between the user and the root organization" do
        $memberships.count.should eq 1
        $memberships.map(&:organization).should =~ [org]
        $memberships.map(&:user).should =~ [user]
        $memberships.map(&:role).should =~ ["Admin"]
      end
    end

    context "when the root organization has a parent organization" do
      before do 
        org.stub(:parent_organizations).and_return([ParentOrganization.new])
        $memberships << Membership.new(user, org, role)
      end

      it "should create a membership for the root organization and the parent organization" do
        $memberships.count.should eq 2
        $memberships.map(&:organization).should =~ [org, org.parent_organizations.first]
        $memberships.map(&:user).should =~ [user, user]
        $memberships.map(&:role).should =~ ["Admin", "Admin"]
      end
    end

    context "when the root organization has a parent and a child organization" do 
      before do 
        org.stub(:parent_organizations).and_return([ParentOrganization.new])
        org.parent_organizations.first.stub(:child_organizations).and_return([ChildOrganization.new])
        $memberships <<  Membership.new(user, org, role)
      end

      it "should create a membership for the root organization, parent organization, and child organization" do 
        $memberships.count.should eq 3
        $memberships.map(&:organization).should =~ [org, org.parent_organizations.first, org.parent_organizations.first.child_organizations.first]
        $memberships.map(&:user).should =~ [user, user, user]
        $memberships.map(&:role).should =~ ["Admin", "Admin", "Admin"]
      end
    end
  end

  describe "parent organization" do
    let(:org) {ParentOrganization.new}
    
    context "when there is only a parent organization" do
      before do
        $memberships << Membership.new(user, org, role)
      end

      it "should create one memberships between the user and the root organization" do
        $memberships.count.should eq 1
        $memberships.map(&:organization).should =~ [org]
        $memberships.map(&:user).should =~ [user]
        $memberships.map(&:role).should =~ ["Admin"]
      end
    end

    context "when there is a parent and child organizations" do
      before do
        org.stub(:child_organizations).and_return([ChildOrganization.new, ChildOrganization.new]) 
        $memberships << Membership.new(user, org, role)
      end

      it "should create memberships for user/parent organizations and user/children organizations" do
        $memberships.count.should eq 3
        $memberships.map(&:organization).should =~ [org, org.child_organizations.first, org.child_organizations.last]
        $memberships.map(&:user).should =~ [user, user, user]
        $memberships.map(&:role).should =~ ["Admin", "Admin", "Admin"]
      end
    end
  end

  describe "child organization" do
    let(:org) {ChildOrganization.new}
    before do 
      $memberships << Membership.new(user, org, role)
    end

    it "should create one membership between the user and the child organization" do 
      $memberships.count.should eq 1
      $memberships.map(&:organization).should =~ [org]
      $memberships.map(&:user).should =~ [user]
      $memberships.map(&:role).should =~ ["Admin"]
    end
  end
end