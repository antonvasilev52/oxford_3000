require 'rubygems'
require 'bundler/setup'
require 'sinatra'
require 'net/http'
require 'json'
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
  # Sends feedback via the Brevo HTTP API (port 443) instead of SMTP,
  # because Render's free plan blocks outbound SMTP ports (25/465/587).
  # So effectively this makes Pony 🐴 unnecessary
  begin
    payload = {
      sender:      { name: 'Oxford 3000', email: 'antoniusvasilev@gmail.com' },
      to:          [{ email: 'antoniusvasilev@gmail.com' }],
      subject:     "Message from #{params[:user]}",
      htmlContent: erb(:mailer)
    }
    reply_to = params[:email].to_s.strip
    unless reply_to.empty? || reply_to !~ /\A[^@\s]+@[^@\s]+\.[^@\s]+\z/
      payload[:replyTo] = { email: reply_to, name: params[:user] }
    end

    uri = URI('https://api.brevo.com/v3/smtp/email')
    request = Net::HTTP::Post.new(uri.request_uri,
                                  'Content-Type' => 'application/json',
                                  'api-key'      => ENV['BREVO_API_KEY'].to_s)
    request.body = payload.to_json

    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.open_timeout = 10
    http.read_timeout = 10
    response = http.request(request)

    warn "Brevo API error: #{response.code} #{response.body}" unless response.is_a?(Net::HTTPSuccess)
  rescue StandardError => e
    warn "Feedback email failed: #{e.class}: #{e.message}"
  end

  erb :feedback
end
