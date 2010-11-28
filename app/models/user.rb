class User < ActiveRecord::Base
  
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

