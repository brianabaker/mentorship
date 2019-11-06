FactoryBot.define do
  factory :user do
    email { "aabb@hh.de" } #properties
    password { "ruby" }
    password_confrimation { "ruby" }
  end
end
