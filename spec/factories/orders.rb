FactoryGirl.define do
  factory :order do
    user nil
		total { rand() * 150 }
  end

end
