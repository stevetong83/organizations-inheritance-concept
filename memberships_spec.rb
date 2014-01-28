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
      before {@m = Membership.new user, org, role}
      before {$memberships << @m}

      it "should create one memberships between the user and the root organization" do
        @m.user.should eq user
        @m.organization.should eq org
        @m.role.should eq role
        $memberships.count.should eq 1
      end
    end

    context "when the root organization has a parent organization" do
      before do 
        org.stub(:parent_organizations).and_return([ParentOrganization.new])
        @m = Membership.new user, org, role
        $memberships << @m
      end

      it "should create a membership for the root organization and the parent organization" do
        @m.user.should eq user
        @m.organization.should eq org
        @m.role.should eq role
        $memberships.count.should eq 2
      end
    end

    context "when the root organization has a parent and a child organization" do 
      before do 
        org.stub(:parent_organizations).and_return([ParentOrganization.new])
        org.parent_organizations.first.stub(:child_organizations).and_return([ChildOrganization.new])
        @m = Membership.new user, org, role
        $memberships << @m
      end

      it "should create a membership for the root organization, parent organization, and child organization" do 
        @m.user.should eq user
        @m.organization.should eq org
        @m.role.should eq role
        $memberships.count.should eq 3
      end
    end
  end

  describe "parent organization" do
    let(:org) {ParentOrganization.new}
    
    context "when there is only a parent organization" do
      before do
        @m = Membership.new user, org, role
        $memberships << @m
      end

      it "should create one memberships between the user and the root organization" do
        @m.user.should eq user
        @m.organization.should eq org
        @m.role.should eq role
        $memberships.count.should eq 1
      end
    end

    context "when there is a parent and child organizations" do
      before do
        org.stub(:child_organizations).and_return([ChildOrganization.new, ChildOrganization.new]) 
        @m = Membership.new user, org, role
        $memberships << @m
      end

      it "should create memberships for user/parent organizations and user/children organizations" do
        @m.user.should eq user
        @m.organization.should eq org
        @m.role.should eq role
        $memberships.count.should eq 3
      end
    end
  end

  describe "child organization" do
    let(:org) {ChildOrganization.new}
    before do 
      @m = Membership.new user, org, role
      $memberships << @m
    end

    it "should create one membership between the user and the child organization" do 
      @m.user.should eq user
      @m.organization.should eq org
      @m.role.should eq role
      $memberships.count.should eq 1
    end
  end
end