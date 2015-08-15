FactoryGirl.define do
	factory :contact do
		firstname { Faker::Name.first_name }
		lastname { Faker::Name.last_name }
		email { Faker::Internet.email }  # ランダムなメールアドレスを使う
		#sequence(:email) { |n| "johndoe#{n}@example.com"}  # sequenceを使って、ブロックの内部でnを自動的にインクリメントする
		after(:build) do |contact|
			[:home_phone, :work_phone, :mobile_phone].each do |phone|
				contact.phones << FactoryGirl.build(:phone,
				  phone_type: phone, contact: contact)
			end
		end
	end
end


