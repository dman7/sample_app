# == Schema Information
#
# Table name: users
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  email      :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class User < ActiveRecord::Base
	attr_accessor :password
	attr_accessible :name, :email, :password, :password_confirmation #Accessible because a user will define these (set them).

	email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

	validates(:name, :presence=>true,
									 :length => {:maximum => 50})
	validates(:email, :presence=> true,
										:format => {:with => email_regex},
										:uniqueness => {:case_sensitive => false})

	#Automatically creates the virtual attribute 'password_confirmation'
	validates :password,:presence => true,
											:confirmation => true,
											:length => {:within => 6..40}
	

	# Encrypting the password
	before_save :encrypt_password

	# Return true if the user's password matches the submitted password.	
	def has_password?(submitted_password)
		# Compare encrypted_password with the encrypted version of
    	# submitted_password.
		self.encrypted_password == encrypt(submitted_password)
  end

	def self.authenticate(email,submitted_password)
		user = find_by_email(email)
		return nil if user.nil?
		return user if user.has_password?(submitted_password)
	end

  def self.authenticate_with_salt(id, cookie_salt)
    user = find_by_id(id)
    (user && user.salt == cookie_salt) ? user : nil
  end

	private
	def encrypt_password
		self.salt = make_salt if self.new_record?
		self.encrypted_password = encrypt(self.password) # see below for implementation
	end

	def encrypt(string)
		secure_hash("#{self.salt}--#{string}")
	end

	def make_salt
		secure_hash("#{Time.now.utc}--#{self.password}")
	end

	def secure_hash(string)
		Digest::SHA2.hexdigest(string)
	end
end

