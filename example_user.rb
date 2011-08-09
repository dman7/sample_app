class User
	attr_accessor :name, :email # this allows us to write a query such as
															# user = User.new; user.name; user.email
															# as well as user.name = "Dmitri"


	def initialize(attributes = {})
		@name = attributes[:name]
		@email = attributes[:email]
	end

	def formatted_email
		"#{@name}<#{@email}>"
	end
end
