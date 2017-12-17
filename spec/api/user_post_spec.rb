require 'rails_helper'

RSpec.describe UsersController, type: :request do
  it 'creates new user' do
    params = {
      full_name: 'Michal Jackson',
      email_address: 'michale@gmail.com'
    }
    # params = params.deep_stringify_keys
    params = params.deep_camelize
    post '/users', params: { user: params }, xhr: true
    expect(response.status).to eq 201
    expect(JSON.parse(response.body)).to include(params)
  end
  it 'updates user' do
    params = {
      full_name: 'Michal Jackson',
      email_address: 'michale@gmail.com'
    }
    user = FactoryBot.create(:user, params)
    params = {
      full_name: 'Michale Jack',
      email_address: 'jack@gmail.com'
    }
    # params = params.deep_stringify_keys
    params = params.deep_camelize
    put "/users/#{user.id}", params: { user: params }, xhr: true
    expect(response.status).to eq 200
    expect(JSON.parse(response.body)).to include(params)
  end
end
