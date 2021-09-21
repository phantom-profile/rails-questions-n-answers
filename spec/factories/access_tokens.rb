FactoryBot.define do
  factory :access_token, class: 'Doorkeeper::AccessToken' do
    association :application, factory: :oauth_app
    resource_owner_id { create(:user).id }
    scopes { 'public' }
    expires_in { 24.hours }
  end
end
