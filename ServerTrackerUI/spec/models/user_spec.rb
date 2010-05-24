# == Schema Information
# Schema version: 20100523235909
#
# Table name: users
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  email      :string(255)
#  created_at :datetime
#  updated_at :datetime
#

require 'spec_helper'

describe User do
  before(:each) do
    @attr = {
      :name => "value for name",
      :email => "value@for.email"
    }
  end

  it "should create a new instance given valid attributes" do
    User.create!(@attr)
  end

  it "should require a name" do
    no_name_user = User.new(@attr.merge(:name => ""))
    no_name_user.should_not be_valid
  end

  it "should require an email" do
    no_name_user = User.new(@attr.merge(:email => ""))
    no_name_user.should_not be_valid
  end

  it "should accept names with lenght of 50" do
    long_name_user = User.new(@attr.merge(:name => 'a'*50))
    long_name_user.should be_valid
   end

  it "should refuse names longer than 50" do
    long_name_user = User.new(@attr.merge(:name => 'a'*51))
    long_name_user.should_not be_valid
  end

  it "should accept valid email addresses" do
    addrs = %w[a@b.c ABB@CDE.FH.HU first.last.blah@foo.org]
    addrs.each do |addr|
      valid_email_user = User.new(@attr.merge(:email => addr))
      valid_email_user.should be_valid
    end
  end

  it "should reject invalid email addresses" do
    addrs = %w[a@b,c ABB_at_CDE.FH.HU first.last.blah@foo.]
    addrs.each do |addr|
      valid_email_user = User.new(@attr.merge(:email => addr))
      valid_email_user.should_not be_valid
    end
  end

  it "should reject duplicated email address" do
    user = User.create!(@attr)
    user_with_duplicate_email = User.new(@attr)
    user_with_duplicate_email.should_not be_valid
  end

  it "should reject duplicated email address up to case" do
    email_upper = @attr[:email].upcase
    user = User.create!(@attr)
    user_with_duplicate_email = User.new(@attr.merge( :email => email_upper))
    user_with_duplicate_email.should_not be_valid
  end

end
