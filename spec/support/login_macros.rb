# userオブジェクトを受け取り、session[:user_id]にユーザーの:idを割り当てます。
module LoginMacros
	def set_user_session(user)
		session[:user_id] = user.id
	end
end
