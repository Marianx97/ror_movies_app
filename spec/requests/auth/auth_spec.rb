require 'rails_helper'

RSpec.describe 'Auth API', type: :request do
  let(:valid_attributes) do
    {
      auth: {
        username: 'testuser',
        email: 'user@example.com',
        password: 'Password@123',
        password_confirmation: 'Password@123'
      }
    }
  end

  let(:invalid_attributes) do
    {
      auth: {
        username: '',
        email: 'invalid',
        password: '123',
        password_confirmation: '456'
      }
    }
  end

  let(:login_credentials) do
    {
      auth: {
        email: 'user@example.com',
        password: 'Password@123'
      }
    }
  end

  let(:wrong_login_credentials) do
    {
      auth: {
        email: 'user@example.com',
        password: 'WrongPassword'
      }
    }
  end

  describe 'POST /auth/register' do
    context 'with valid attributes' do
      it 'creates a new user and returns a token' do
        post '/auth/register', params: valid_attributes
        expect(response).to have_http_status(:created)
        expect(JSON.parse(response.body)).to include('access_token')
      end
    end

    context 'with missing params' do
      it 'returns bad request for missing auth param key' do
        post '/auth/register', params: {}
        expect(response).to have_http_status(:bad_request)
        expect(JSON.parse(response.body)).to include("message" => 'Bad Request')
      end
    end

    context 'with invalid data' do
      it 'returns validation errors' do
        post '/auth/register', params: invalid_attributes
        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)).to include('errors')
      end
    end
  end

  describe 'POST /auth/login' do
    before { post '/auth/register', params: valid_attributes }

    context 'with valid credentials' do
      it 'returns a JWT token' do
        post '/auth/login', params: login_credentials
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)).to include('access_token')
      end
    end

    context 'with invalid password' do
      it 'returns unauthorized' do
        post '/auth/login', params: wrong_login_credentials
        expect(response).to have_http_status(:unauthorized)
        expect(JSON.parse(response.body)).to include('errors')
      end
    end

    context 'with missing email/password' do
      it 'returns bad request' do
        post '/auth/login', params: { auth: { email: '' } }
        expect(response).to have_http_status(:bad_request)
        expect(JSON.parse(response.body)).to include('errors')
      end
    end

    context 'with missing auth key' do
      it 'returns bad request' do
        post '/auth/login', params: {}
        expect(response).to have_http_status(:bad_request)
        expect(JSON.parse(response.body)).to include('message' => 'Bad Request')
      end
    end
  end
end
