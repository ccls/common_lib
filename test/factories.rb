Factory.define :blog do |f|
	f.association :user
	f.sequence(:title) { |n| "Title #{n}" }
#	f.sequence(:description) { |n| "Desc#{n}" }
end
Factory.define :post do |f|
	f.association :blog
	f.sequence(:title) { |n| "Title #{n}" }
#	f.sequence(:body) { |n| "Desc#{n}" }
end
Factory.define :product do |f|
	f.sequence(:name) { |n| "Name #{n}" }
end
Factory.define :vendor do |f|
	f.sequence(:name) { |n| "Name #{n}" }
end
Factory.define :user do |f|
	f.sequence(:name) { |n| "Name #{n}" }
	f.sequence(:zip_code) { |n| sprintf("%05d",n) }
end

Factory.define :hash_like do |f|
	f.sequence(:key)  { |n| "Key #{n}" }
	f.sequence(:value){ |n| "Value #{n}" }
end
Factory.define :private do |f|
	f.sequence(:name)  { |n| "Name #{n}" }
end
