require 'rails_helper'

describe 'CreateUser', type: :request do
  describe 'create user mutation' do
    let(:test_user) { FactoryBot.build(:user) }
    let(:test_query) {
      <<~GQL
          mutation{
            createUser(
              input: {
                email: "#{test_user.email}",
                password: "#{test_user.password}"
              }
            ) {
              user {
                id
                email
              }
              errors
            }
          }
      GQL
    }
    let(:parsed_response) { JSON.parse(response.body).deep_symbolize_keys[:data][:createUser] }

    it 'creates a user' do
      expect{ post '/graphql', params: {query: test_query} }.to change{ User.count }.by 1
    end

    it 'returns the anticipated fields' do
      post '/graphql', params: {query: test_query}
      expect(parsed_response[:user]).to include({
        id: be_present,
        email: test_user.email
      })
      expect(parsed_response[:errors]).to be_empty
    end

    it 'returns an error when something goes wrong' do
      test_user.save # ie, violating email uniqueness
      post '/graphql', params: {query: test_query}
      expect(parsed_response[:user]).to be_nil
      expect(parsed_response[:errors]).to eq(["Email has already been taken"])
    end
  end
end