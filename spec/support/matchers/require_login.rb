RSpec::Matchers.define :require_login do |expected|
	# 期待することを書く.
	# expect().to以下を置き換える.
	# RSpecはRailsのUrlHelpersライブラリを読み込まないので、パスの呼び出しは省略せずに全部書いてやる必要がある.
	# actual == response が、ログインフォームにリダイレクトするか.
	match do |actucal|
		expect(actual).to redirect_to \
			Rails.application.routes.url_helpers.login_path
	end

	# exampleがパスしなかったときに返すメッセージ
	failure_message do |actual|
		"expected to require login to access the method"
	end

	failure_message_when_negated do |actual|
		"expected not to require login to access the method"
	end

	description do
		"redirect to the login form"
	end
end


