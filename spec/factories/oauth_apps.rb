FactoryBot.define do
  factory :oauth_app, class: 'Doorkeeper::Application' do
    name { 'test' }
    redirect_uri { 'urn:ietf:wg:oauth:2.0:oob' }
    uid { 'UID' }
    secret { 'secret' }
  end
end
