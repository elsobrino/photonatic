require 'digest'
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
                       :length => { :maximum => 50 },
                       :uniqueness => true
  validates :email,    :presence => true,
                       :format => { :with => email_regex },
                       :length => { :within => 5..255 },
                       :uniqueness => true
  validates :password, :confirmation => true,
                       :presence => true,
                       :length => { :within => 6..40 }
                       
  before_save :encrypt_password
  
  def self.authenticate(email, submitted_password)
    user = find_by_email(email)
    return nil if user.nil?
    if user.has_password?(submitted_password)
      return user
    else
      return nil
    end
  end
  
  def has_password?(submitted_password)
    encrypted_password == encrypt(submitted_password)
  end
  
  private
    
    def encrypt_password
      self.salt = make_salt if new_record?
      self.encrypted_password = encrypt(password)
    end
    
    def encrypt(string)
      secure_hash("#{salt}--#{string}")
    end
    
    def make_salt
      secure_hash("#{Time.now.utc}--#{password}")
    end
    
    def secure_hash(string)
      Digest::SHA2.hexdigest(string)
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

