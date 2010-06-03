require 'spec_helper'

describe UsersController do
  integrate_views

  describe "GET 'show'" do
    before(:each) do
      @user = Factory(:user)
      # Arrange for User.find(params[:id]) to find the right user.
      User.stub!(:find, @user.id).and_return(@user)
    end

    it "should be successfull" do
      get :show, :id => @user
      response.should be_success
    end

    it "should have the right title" do
      get :show, :id => @user
      response.should have_tag("title", /#{@user.name}/)
    end

    it "should include the user's name" do
      get :show, :id => @user
      response.should have_tag("h2", /#{@user.name}/)
    end

    it "should have a profile image" do
      get :show, :id => @user
      response.should have_tag("h2>img", :class => "gravatar")
    end
  end

  describe "GET 'new'" do
    it "should be successful" do
      get 'new'
      response.should be_success
    end

    it "should have the right title" do
      get 'new'
      response.should have_tag("title", /Sign up/)
    end
  end

  describe "POST 'create'" do

    describe "failure" do
      before(:each) do
        @attr = {:name => "", :email => "", :password => "", :password_confirmation => ""}
        @user = Factory.build(:user, @attr)
        User.stub!(:new).and_return(@user)
        @user.should_receive(:save).and_return(false)
      end

      it "should have the right title" do
        post :create, :user => @attr
        response.should have_tag("title", /sign up/i)
      end

      it "should render the 'new' page" do
        post :create, :user => @attr
        response.should render_template('new')
      end
    end

    describe "success" do
      before(:each) do
        @attr = {:id => "1", :name => "new user", :email => "user@example.com", :password => "foobar", :password_confirmation => "foobar"}
        @user = Factory.build(:user, @attr)
        User.stub!(:new).and_return(@user)
        @user.should_receive(:save).and_return(true)
      end

      it "should render the user's 'show' page" do
        post :create, :user => @attr
        response.should redirect_to(user_path(@user))
      end

      it "should have a welcome message" do
        post :create, :user => @attr
        flash[:success].should =~ /welcome to servertracker/i
      end

      it "should leave the user signed in" do
        post :create, :user => @attr
        controller.should be_signed_in
      end
    end
  end

  describe "GET 'edit'" do
    before(:each) do
      @user = Factory(:user)
      test_sign_in(@user)
    end

    it "should be successfull" do
      get :edit, :id => @user
      response.should be_success
    end

    it "should have the right title" do
      get :edit, :id => @user
      response.should have_tag('title', /edit user/i)
    end

    it "should have a link to change the gravatar" do
      get :edit, :id => @user
      gravatar_url = "http://gravatar.com/emails"
      response.should have_tag("a[href=?]", gravatar_url, /change/i)
    end
  end

  describe "PUT 'update'" do
    before(:each) do
      @user = Factory(:user)
      test_sign_in(@user)
      User.should_receive(:find).with(@user).and_return(@user)
    end

    describe "failure" do
      before(:each) do
        @invalid_attr = {:email => "", :name => ""}
        @user.should_receive(:update_attributes).and_return(false)
      end

      it "should render the 'edit' page" do
        put :update, :id => @user, :user => {}
        response.should render_template('edit')
      end

      it "should have the right title" do
        put :update, :id => @user, :user => {}
        response.should have_tag("title", /edit user/i)
      end
    end

    describe "success" do
      before(:each) do
        @attr = {:email => "testuser@test.com", :name => "tester", :password => "foobar", :password_confirmation => "foobar"}
        @user.should_receive(:update_attributes).and_return(true)
      end

      it "should redirect to the user's 'show' page" do
        put :update, :id => @user, :user => {}
        response.should redirect_to(user_path(@user))
      end

      it "should have the success indication" do
        put :update, :id => @user, :user => {}
        flash[:success].should =~ /updated/i
      end

    end

  end

  describe "authentication of edit/update pages" do
    before(:each) do
      @user = Factory(:user)
    end

    describe "for non-signed-in users" do
      it "should deny access to 'edit'" do
        get :edit, :id => @user
        response.should redirect_to(signin_path)
      end

      it "should deny access to 'update'" do
        put :update, :id => @user, :user => {}
        response.should redirect_to(signin_path)
      end
    end

    describe "for signed in users" do
      before(:each) do
        @wrong_user = Factory(:user, :email => "wrong@email.com")
        test_sign_in(@wrong_user)
      end

      it "should require matching user for 'edit'" do
        get :edit, :id => @user
        response.should redirect_to(root_path)
      end

      it "should require matching user for 'update'" do
        put :update, :id => @user, :user => {}
        response.should redirect_to(root_path)
      end
    end
  end
end
