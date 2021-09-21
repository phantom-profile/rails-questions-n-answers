shared_examples_for 'attachable' do
  it { is_expected.to accept_nested_attributes_for :links }
  it { is_expected.to have_many(:links).dependent(:destroy) }

  it { is_expected.to accept_nested_attributes_for :links }

  it 'has many attached files' do
    expect(described_class.new.files).to be_instance_of ActiveStorage::Attached::Many
  end
end
