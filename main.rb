require 'rubygems'
require 'bundler/setup'
require 'sinatra'
require 'pony'
require './dictionaries/definitions'
require './dictionaries/thesaurus_definitions'
require './dictionaries/thesaurus_synonyms'
require './dictionaries/thesaurus_antonyms'
require './dictionaries/thesaurus_usage'

$right_answers = 0
$wrong_answers = 0
$right_answers_arr = []
$wrong_answers_arr = []


get '/' do
  erb :index
end

##
# This is your documentation.
#
# And then some.
#
post '/' do

  if params['reset'] == 'true'
    $right_answers = 0
    $wrong_answers = 0
    $wrong_answers_arr = []
    redirect '/'
  end

  case params['mode']
  when 'thesaurus'
    $scope = $thesaurus_definitions # these are the names of global variables (arrays of hashes) added using require above
    $mode_name = 'Thesaurus definitions'
  when 'synonyms'
    $scope = $thesaurus_synonyms
    $mode_name = 'Thesaurus synonyms'
  when 'dictionary'
    $scope = $definitions
    $mode_name = 'Dictionary definitions'
  when 'antonyms'
    $scope = $thesaurus_antonyms
    $mode_name = 'Thesaurus antonyms'
  when 'usage'
    $scope = $thesaurus_usage
    $mode_name = 'Usage examples'
  end

  redirect '/quiz'
end

##
# Hey! Another method!
get '/quiz' do
  $arr = []
  # This is the method to fill an array
  def unique_random
    # Sets the publisher name for the list.
    random_number = rand($scope.length)
      until $arr.length > 3
      if $arr.length == 0
        $arr << random_number
      elsif $arr.include?(random_number) || $scope[random_number]['part'] != $scope[$arr[0]]['part']
        random_number = rand($scope.length)
      else
          $arr << random_number
        end
      end
  end
  unique_random
  # "Hello #{$arr}"
  $word = $scope[$arr[0]]
  $right_definition = $scope[$arr[0]]['definition']

  # "Hello #{$arr} and #{$arr.shuffle}"
  # "Hello! Word is #{@word['word']}. Definition is \"#{@word['definition']}\"."
  erb :quiz

end

post '/quiz' do

  if params['definition'] == $right_definition
    $right_answers = $right_answers + 1
  else
    $wrong_answers += 1
    $wrong_answers_arr << $word
  end

  if $right_answers + $wrong_answers == 4
    sleep 1.5
    erb :results
  else
    sleep 1.5
    redirect '/quiz'
  end
end



post '/send' do
  apipasswd = ENV['sendinblue']
  Pony.mail(:to => 'antoniusvasilev@gmail.com', :via => :smtp, :from => 'antoniusvasilev@gmail.com',
            :subject => "Message from #{params[:user]}",
            #:body => "Message: #{params[:message]}.\nIP: #{request.ip}.\nUser agent: #{request.user_agent}.",
            :body => erb(:mailer),
            :via_options => {
       :address => 'smtp-relay.sendinblue.com',
      :port => '587',
      :domain => 'heroku.com',
      :user_name => 'antoniusvasilev@gmail.com',
      :password => apipasswd,
      :authentication => :plain,
      :enable_starttls_auto => true
  } )
  erb :feedback
  # "Kek #{apipasswd}"
  # "Lol: #{request.media_type}"
end
