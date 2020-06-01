require 'rails_helper'

describe 'CreateUser', type: :request do
  describe 'create user mutation' do
    let(:test_user) { build(:user) }
    let(:test_query) {
      <<~GQL
          mutation{
            createUser(
              input: {
                email: "#{test_user.email}",
                password: "#{test_user.password}"
              }
            ) {
              id
              email
            }
          }
      GQL
    }

    it 'creates a user' do
      expect{ post '/graphql', params: {query: test_query} }.to change{ User.count }.by 1
    end

    it 'returns the anticipated fields' do
      post '/graphql', params: {query: test_query}
      returned_user = JSON.parse(response.body).deep_symbolize_keys[:data][:createUser]
      expect(returned_user).to include({
        id: be_present,
        email: test_user.email
      })
    end

    
  end
end