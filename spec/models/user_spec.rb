require 'spec_helper'

describe User do

  before(:each) do
    @attr = {
      :forename => "Test",
      :lastname => "User",
      :username => "Hans-Dieter",
      :email => "test@example.com",
      :password => "foobar",
      :password_confirmation => "foobar"
    }
  end
  
  it "should create a new user with valid data" do
    User.create!(@attr)
  end
  
  describe "Testing forename validation" do
  
    it "should not require a forename" do
      no_forename_user = User.new(@attr.merge(:forename => ""))
      no_forename_user.should be_valid
    end
  
    it "should require an alphabetical forename" do
      non_alphabetical_forenames = %w[John! Mike% Nick123 K.]
      non_alphabetical_forenames.each do |forename|
        invalid_user = User.new(@attr.merge(:forename => forename))
        invalid_user.should_not be_valid
      end
    end
  
    it "should pass with valid forename" do
      valid_forenames = %w[Steven Hans Robert Theo]
      valid_forenames.each do |forename|
        valid_user = User.new(@attr.merge(:forename => forename))
        valid_user.should be_valid
      end
    end
  
    it "should reject too long forenames" do
      long_forename = "a"*51
      to_long_forename = User.new(@attr.merge(:forename => long_forename))
      to_long_forename.should_not be_valid
    end
  end
  
  describe "Testing lastname validation" do
  
    it "should not require a lastname" do
      no_lastname_user = User.new(@attr.merge(:lastname => ""))
      no_lastname_user.should be_valid
    end
  
    it "should require an alphabetical lastname" do
      non_alphabetical_lastnames = %w[Meyer! Sch$ulz Schmidt1324 M.]
      non_alphabetical_lastnames.each do |lastname|
        invalid_user = User.new(@attr.merge(:lastname => lastname))
        invalid_user.should_not be_valid
      end
    end
  
    it "should pass with valid lastnames" do
      valid_lastnames = %w[Meyer Schulz Mueller Schmidt]
      valid_lastnames.each do |lastname|
        valid_user = User.new(@attr.merge(:lastname => lastname))
        valid_user.should be_valid
      end
    end
  
    it "should reject too long lastnames" do
      long_lastname = "a"*51
      to_long_lastname = User.new(@attr.merge(:lastname => long_lastname))
      to_long_lastname.should_not be_valid
    end
  end

  describe "Testing username validation" do

    it "should require a username" do
      User.new(@attr.merge(:username => "")).should_not be_valid
    end

    it "should not be longer than 50 chars" do
      long_name = "a"*51
      User.new(@attr.merge(:username => long_name)).should_not be_valid
    end

    it "should reject duplicate usernames" do
      User.create!(@attr)
      User.new(@attr.merge(:email => "test2@example.com")).should_not be_valid
    end

  end

  describe "Testing email address validation" do
    
    it "should require a email address" do
      no_email_user = User.new(@attr.merge(:email => ""))
      no_email_user.should_not be_valid
    end
  
    it "should accept valid email addresses" do
      addresses = %w[user@foo.com THE_USER@foo.bar.org first.last@foo.jp]
      addresses.each do |address|
        valid_email_user = User.new(@attr.merge(:email => address))
        valid_email_user.should be_valid
      end
    end

    it "should reject invalid email address" do
      addresses = %w[user@foo,com user_at_foo.org example_user@foo.]
      addresses.each do |address|
        invalid_email_user = User.new(@attr.merge(:email => address))
        invalid_email_user.should_not be_valid
      end
    end
  
    it "should reject too long email address" do
      long_email = "#{'a'*255}@ab.de"
      to_long_email = User.new(@attr.merge(:email => long_email))
      to_long_email.should_not be_valid
    end

    it "should reject duplicate email addresses" do
      User.create!(@attr)
      User.new(@attr.merge(:username => "Hans")).should_not be_valid
    end
  end

  describe "Testing password validation" do
  
    it "should reject password/confirmation mismatch" do
      User.new(@attr.merge(:password => 'foobaz')).
                should_not be_valid
    end
  
    it "should reject passwords shorter than 6 chars" do
      User.new(@attr.merge(:password => 'abcde', 
                           :password_confirmation => 'abcde')).
              should_not be_valid
    end
   
    it "should reject passwords longer than 40 chars" do
      long_password = 'a'*41
      User.new(@attr.merge(:password => long_password,
                           :password_confirmation => long_password)).
               should_not be_valid
    end
    
    it "should reject empty passwords" do
      User.new(@attr.merge(:password => "", :password_confirmation => "")).
               should_not be_valid
    end
  end
  
  describe "password encryption" do
    
    before(:each) do
      @user = User.create!(@attr)
    end
    
    it "should have an encrypted password attribute" do
      @user.should respond_to(:encrypted_password)
    end
    
    it "should set the encrpyted password" do
      @user.encrypted_password.should_not be_blank
    end
    
    describe "has_password? method" do
      
      it "should be true if the passwords match" do
        @user.has_password?(@attr[:password]).should be_true
      end
      
      it "should be fale if the passwords don't match" do
        @user.has_password?("invalid").should be_false
      end
    end
    
    describe "authenticate method" do
      
      it "should return nil on email/password mismatch" do
        wrong_password_user = User.authenticate(@attr[:email], "wrongpass")
        wrong_password_user.should be_nil
      end
      
      it "should return nil for an email address with no user" do
        noexistent_user = User.authenticate("bar@foo.com", @attr[:password])
        noexistent_user.should be_nil
      end
      
      it "should return the user on email/password match" do
        matching_user = User.authenticate(@attr[:email], @attr[:password])
        matching_user.should == @user
      end
    end
  end
end



# == Schema Information
#
# Table name: users
#
#  id                 :integer(4)      not null, primary key
#  forename           :string(255)
#  lastname           :string(255)
#  email              :string(255)
#  encrypted_password :string(255)
#  salt               :string(255)
#  created_at         :datetime
#  updated_at         :datetime
#  username           :string(255)
#

