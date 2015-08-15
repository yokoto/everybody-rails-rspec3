FactoryGirl.define do
	factory :phone do
		association :contact
		phone { Faker::PhoneNumber.phone_number }  # 一意で、ランダムで、本物っぽい番号を付与する

		factory :home_phone do
			phone_type 'home'
		end

		factory :work_phone do
			phone_type 'work'
		end

		factory :mobile_phone do
			phone_type 'mobile'
		end
	end
end
