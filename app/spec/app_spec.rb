require_relative './spec_helper.rb'
require_relative '../app.rb'

# tests that check responses are feature tests not unit tests
# unit tests should be tightly scoped to just the one thing that they're doing
RSpec.describe App do
  describe('#post /login') do
    context('when the user is valid') do
      it('redirects to "/"') do
        post('/login', {
          phone: '1112223333',
          password: 'password1'
        })
        expect(last_response).to be_redirect
        follow_redirect!
        expect(last_request.url).to eq('http://example.org/')
      end
    end
  end
end
