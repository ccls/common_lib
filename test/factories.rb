FactoryGirl.define do
	factory :blog do |f|
		f.association :user
		f.sequence(:title) { |n| "Title #{n}" }
	#	f.sequence(:description) { |n| "Desc#{n}" }
	end
	factory :post do |f|
		f.association :blog
		f.sequence(:title) { |n| "Title #{n}" }
	#	f.sequence(:body) { |n| "Desc#{n}" }
	end
	factory :product do |f|
		f.sequence(:name) { |n| "Name #{n}" }
	end
	factory :vendor do |f|
		f.sequence(:name) { |n| "Name #{n}" }
	end
	factory :user do |f|
		f.sequence(:name) { |n| "Name #{n}" }
		f.sequence(:zip_code) { |n| sprintf("%05d",n) }
	end
	
	factory :hash_like do |f|
		f.sequence(:key)  { |n| "Key #{n}" }
		f.sequence(:value){ |n| "Value #{n}" }
	end
	factory :private do |f|
		f.sequence(:name)  { |n| "Name #{n}" }
	end
	factory :validator do |f|
	end
end
