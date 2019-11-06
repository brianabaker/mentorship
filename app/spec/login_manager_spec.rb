require 'rack/test'
require 'rspec'
require 'pry'
# require 'factory_bot'

# FactoryBot.definition_file_paths = %w{./factories ./spec/factories}
# FactoryBot.find_definitions

ENV['RACK_ENV'] = 'test'

require_relative '../app.rb'

# . is when it's a class method
# # is when it's an instance method
# mocking is for saving time and allowing us to isolate what we're testing
# context is a code path
# an find it from looking for the conditionals
# subject is the thing you're performing the test on
RSpec.describe LoginManager do
  FactoryBot.factory :lookup_helper do
    user_list {
      [{ phone: '111', password: 'pass' }]
    }
  end

  user_lookup_helper = FactoryBot.create(:lookup_helper)

  let(:user_lookup_helper) {
    d = double(:user_lookup_helper)

    allow(d)
      .to receive(:lookup_user)
      .and_return(nil)

    allow(d)
      .to receive(:lookup_user)
      .with('111', 'pass')
      .and_return({ phone: '111', password: 'pass' })

    d
  }
  subject { LoginManager.new(user_lookup_helper) }

  describe('#login') do
    context('when a user is not found') do
      it('return "/login') do
        path = subject.login('100', 'password')
        expect(path).to eq '/login'
      end
    end

    context('when a user is found') do
      it('returns "/"') do
        path = subject.login('111', 'pass')
        expect(path).to eq '/'
      end
    end

    # context('when the given phone does not match any of the phones in the valid users table') do
    #   it('returns "/login"') do
        # path = LoginManager.login('111', 'password1')
        # expect(path).to eq '/login'
    #   end
    # end
    # context('when the phone does match any of the phones in the valid users table') do
    #   context('when the given password does not match any of the passwords in the valid users table') do
    #     it('returns "/login"') do
    #       path = LoginManager.login('1112223333', 'paasdlkfjs')
    #     expect(path).to eq '/login'
    #     end
    #   end
      # context('when the given password does match any of the passwords in the valid users table') do
      #   it('returns "/"') do
      #     path = LoginManager.login('1112223333', 'password1')
      #     expect(path).to eq '/'
      #   end
      # end
    # end
  end
end
