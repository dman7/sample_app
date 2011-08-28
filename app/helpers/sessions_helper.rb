module SessionsHelper
	def sign_in(user)
		cookies.permanent.signed[:remember_token] = [user.id, user.salt] #permanent. sets it to 20.years.from_now
		#cookies[:remember_token] = {:expires => 2.minutes.from_now.utc } #{ :value => user.id, :expires => 2.minutes.from_now.utc }
    self.current_user = user
  end

	def current_user=(user)
		@current_user = user
	end

	def signed_in?
		!current_user.nil?
	end

	def current_user?(user)
		user == self.current_user
	end

	def deny_access
		store_location
		redirect_to signin_path, :notice => "Please sign in to access this page." # Or: flash[:notice] = "Please..."
	end

  def current_user
    @current_user ||= user_from_remember_token
  end

	def sign_out
		cookies.delete(:remember_token)
		self.current_user = nil
	end

	def redirect_back_or(default)
    redirect_to(session[:return_to] || default)
    clear_return_to
  end


	private
		def user_from_remember_token
			User.authenticate_with_salt(*remember_token)
		end

		def remember_token
			cookies.signed[:remember_token] || [nil, nil]
		end

    def store_location
      session[:return_to] = request.fullpath
    end

    def clear_return_to
      session[:return_to] = nil
    end
end
