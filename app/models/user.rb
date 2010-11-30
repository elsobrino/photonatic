class User < ActiveRecord::Base
  attr_accessor :password
  attr_accessible :forename, :lastname, :email, :password, :password_confirmation, :username
  
  alpha_regex = /^[A-Z][a-z]+$/
  email_regex = /^[\w+\-.]+@[a-z\d\-.]+\.[a-z]+$/i
  
  validates :forename, :allow_blank => true,
                       :format => { :with => alpha_regex },
                       :length => { :maximum => 50 }
  validates :lastname, :allow_blank => true,
                       :format => { :with => alpha_regex },
                       :length => { :maximum => 50 }
  validates :username, :presence => true,
                       :length => { :maximum => 50 }
  validates :email,    :presence => true,
                       :format => { :with => email_regex },
                       :length => { :within => 5..255 }
  validates :password, :confirmation => true,
                       :presence => true,
                       :length => { :within => 6..40 }
  
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
#

