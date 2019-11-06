require 'sinatra'

VALID_USERS = [
  {
    phone: '1112223333',
    password: 'password1'
  }
].freeze

VALID_ADMINS = [
  {
    phone: '555555555',
    password: 'password1'
  }
].freeze

# A comment
class App < Sinatra::Base
  get '/' do
    'Successfully logged in'
  end

  get '/login' do
    File.read('login.html')
  end

  post '/login' do
    # gets parameters that we send from the form
    user_lookup_helper = LookupHelper.new(VALID_USERS)
    user_login_manager = LoginManager.new(user_lookup_helper)

    admin_lookup_helper = LookupHelper.new(VALID_ADMINS)
    admin_login_manager = LoginManager.new(admin_lookup_helper)

    twilio = Twilio.new()
    twilio_login_manager = LoginManager.new(twilio)

    path = user_login_manager.login(params[:phone], params[:password])

    if path == "/login"
      path = admin_login_manager.login(params[:phone], params[:password])
    end

    redirect path
  end
end

# writing the actual code for how it will be used
class LoginManager
  def initialize(a_thing_that_can_lookup)
    @a_thing_that_can_lookup = a_thing_that_can_lookup
  end

  def login(phone, password)
    user = a_thing_that_can_lookup.lookup(phone, password)
    if user.nil?
      '/login'
    else
      '/'
    end
  end

  private

  attr_reader :a_thing_that_can_lookup
end

# extracting this into its own class makes it easier to write unit tests
# and keeps the classes smaller
# Extracting something to make something else easier is a good enough
# But also a balance with not doing more than you need to get something going
# (a la 99 bottles)
class LookupHelper
  def initialize(user_list)
    @user_list = user_list
  end

  def lookup(phone, password)
    user_list.find do |item|
      item[:phone] == phone && item[:password] == password
    end
  end

  private

  attr_reader :user_list
end

# a comment
class Twilio
  def lookup(phone, password)
    # ...
  end
end

# a comment
class JobRunner
  def initialize(jobs)
    @jobs = jobs
  end

  def run()
    @jobs.each { |job| job.run }
  end
end

# a comment
class StringThing
  def initialize(str)
  end

  def run()
    # ...
  end
end

# a comment
class NumberThing
  def run()
    # ...
  end
end

# string_thing_a = StringThing.new("a")
# string_thing_b = StringThing.new("b")
# number_thing_1 = NumberThing.new(1)
# # creating a new instance
# string_job_runner = JobRunner.new([string_thing_a, string_thing_b])
# number_job_runner = JobRunner.new([number_thing_1])

# everything_job_runner = JobRunner.new([string_job_runner, number_job_runner])
# everything_job_runner.run

# warn_logger = RailsLogger.new(level: :warn)
# red_logger = RailsLogger.new(color: :red)
# error_logger = RailsLogger.new(level: :error, color: :red, weight: :bold)

# warn_logger.log("blah")

# warn_logger_2 = RailsLogger.new(level: :warn)
# warn_logger_2.log("blah")

# # js below

# console # is an instance of Console, but the only one.

# const console2 = new Console();
# const console3 = new Console();

# console2.log("blah")
