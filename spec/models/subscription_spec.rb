# frozen_string_literal: true

RSpec.describe Subscription, type: :model do
  it { is_expected.to belong_to(:subscriptable) }
  it { is_expected.to belong_to(:user) }

  it { is_expected.to validate_presence_of :subscriptable }
  it { is_expected.to validate_presence_of :user }
end
