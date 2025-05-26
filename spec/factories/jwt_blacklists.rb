FactoryBot.define do
  factory :jwt_blacklist do
    jti { "MyString" }
    exp { "2025-05-25 14:14:08" }
  end
end
