shared_examples_for 'API authorizable' do
  context 'when unauth user' do
    it 'returns 401 status if there is no access token' do
      # headers = {} if method.to_s != 'get'
      do_request(method.to_s, api_path, { headers: headers })

      expect(response.status).to eq 401
    end

    it 'returns 401 status if access_token is invalid' do
      # headers = {} if method.to_s != 'get'
      do_request(method.to_s, api_path, { headers: headers, params: { access_token: '123456' } })

      expect(response.status).to eq 401
    end
  end
end
