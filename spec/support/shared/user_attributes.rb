shared_examples_for 'readable profiles' do
  it 'returns 200 status' do
    expect(response).to be_successful
  end

  it 'returns all public fields' do
    user_public_fields = %w[id email admin created_at updated_at]
    user_public_fields.each { |attr| expect(checked_user[attr]).to eq user_object.send(attr).as_json }
  end

  it 'does not return all private fields' do
    user_private_fields = %w[password encrypted_password]
    user_private_fields.each { |attr| expect(checked_user).not_to have_key attr }
  end
end
