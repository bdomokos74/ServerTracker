# == Schema Information
# Schema version: 20100619103053
#
# Table name: users
#
#  id                 :integer         not null, primary key
#  name               :string(255)
#  email              :string(255)
#  created_at         :datetime
#  updated_at         :datetime
#  encrypted_password :string(255)
#  salt               :string(255)
#  remember_token     :string(255)
#  admin              :boolean
#

require 'spec_helper'

describe User do

  before(:each) do
    @attr = {
            :name => "Example User",
            :email => "example@user.com",
            :password => "examplepass",
            :password_confirmation => "examplepass"
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
    addrs = %w[ a@b.c ABB@CDE.FH.HU first.last.blah@foo.org ]
    addrs.each do |addr|
      valid_email_user = User.new(@attr.merge(:email => addr))
      valid_email_user.should be_valid
    end
  end

  it "should reject invalid email addresses" do
    addrs = %w[ a@b,c ABB_at_CDE.FH.HU first.last.blah@foo. ]
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
    user_with_duplicate_email = User.new(@attr.merge(:email => email_upper))
    user_with_duplicate_email.should_not be_valid
  end

  describe "password validations" do
    it "should require a password" do
      User.new(@attr.merge(:password => "", :password_confirmation => "")).
              should_not be_valid
    end

    it "should require a matching password confirmation" do
      User.new(@attr.merge(:password_confirmation => "invalid")).
              should_not be_valid
    end

    it "should reject short passwords" do
      short_pass = "a"*5
      hash = @attr.merge(:password => short_pass, :password_confirmation => short_pass)
      User.new(hash).should_not be_valid
    end

    it "should reject long passwords" do
      long_pass = "a"*5
      hash = @attr.merge(:password => long_pass, :password_confirmation => long_pass)
      User.new(hash).should_not be_valid
    end

  end

  describe "passwod encryption" do
    before(:each) do
      @user = User.create!(@attr)
    end

    it "should have an encrypted_password attribute" do
      @user.should respond_to(:encrypted_password)
    end

    it "should set the encrypted_password attribute" do
      @user.encrypted_password.should_not be_blank
    end

    describe "has_password? method" do

      it "should return true if passwords match" do
        @user.has_password?(@attr[:password]).should be_true
      end

      it "should return false if passwords do not match" do
        @user.has_password?("invalid").should be_false
      end
    end

    describe "authenticate method" do
      it "should return nil if user with given email does not exist" do
        User.authenticate("invalid@address.com", "dontcare").should be_nil
      end

      it "should return nil if password for user with email do not match" do
        User.authenticate("example@user.com", "wrongpass").should be_nil
      end

      it "should return user if password for user with email do match" do
        user = User.authenticate("example@user.com", "examplepass")
        user.should == @user
      end

    end

  end

  describe "remember me" do

    before(:each) do
      @user = User.create!(@attr)
    end

    it "should have a remember_me! method" do
      @user.should respond_to(:remember_me!)
    end

    it "should have a remember token" do
      @user.should respond_to(:remember_token)
    end

    it "should set the remember token" do
      @user.remember_me!
      @user.remember_token.should_not be_nil
    end
  end

  describe "admin attr" do
    before(:each) do
      @user = User.create!(@attr)
    end

    it "should respond to admin" do
      @user.should respond_to(:admin)
    end

    it "should not be admin by default" do
      @user.should_not be_admin
    end

    it "should be convertible to admin" do
      @user.toggle!(:admin)
      @user.should be_admin
    end

  end
end
