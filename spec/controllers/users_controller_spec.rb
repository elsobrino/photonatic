require 'spec_helper'

describe UsersController do
  render_views

  describe "GET 'new'" do

    it "should be successful" do
      get 'new'
      response.should be_success
    end
      
    it "should have the correct title" do
      get 'new'
      response.should have_selector('title', :content => "Register")
    end
  end

  describe "POST 'create'" do
    
    describe "failure" do

      before(:each) do 
        @attr = { :username => "", :email => "", :password => "",
                  :password_confirmation => "" }
      end

      it "should not create a new user" do
        lambda do
          post :create, :user => @attr
        end.should_not change(User, :count)
      end

      it "should have the right title" do
        post :create, :user => @attr
        response.should have_selector('title', :content => "Register")
      end

      it "should render the 'new' page" do
        post :create, :user => @attr
        response.should render_template('new')
      end

    end

    describe "success" do
      
      before(:each) do
        @attr = { :username => "Tester", :email => "test@example.com", 
                  :password => 'foobar', :password_confirmation => 'foobar' }
      end

      it "should create a new user" do
        lambda do
          post :create, :user => @attr
        end.should change(User, :count).by(1)
      end

      it "should redirect to the home page" do
        post :create, :user => @attr
        response.should redirect_to(root_path)
      end
      
      it "should sign the user in" do
        post :create, :user => @attr
        controller.should be_signed_in
      end
    end
  end

end
