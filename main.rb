require 'rubygems'
require 'bundler/setup'
require 'sinatra'
require './definitions'
require './thesaurus_definitions'
require './thesaurus_synonyms'

$right_answers = 0
$wrong_answers = 0

get '/' do
  erb :index
end

post '/' do
  if params['reset'] == 'true'
    $right_answers = 0
    $wrong_answers = 0
    redirect '/'
  end

  case params['mode']
  when 'thesaurus'
    $scope = $thesaurus_definitions
    $mode_name = 'Thesaurus definitions'
  when 'synonyms'
    $scope = $thesaurus_synonyms
    $mode_name = 'Thesaurus synonyms'
  when 'dictionary'
    $scope = $definitions
    $mode_name = 'Dictionary definitions'
  end

  redirect '/quiz'
end

get '/quiz' do
  $arr = []
  def unique_random
    random_number = rand(2999)
    until $arr.length > 4
      if $arr.include?(random_number)
        random_number = rand(300)
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
  # "Hello! Word is #{@word['word']}. Defintion is \"#{@word['definition']}\"."
  erb :quiz

end

post '/quiz' do

  if params['definition'] == $right_definition
    $right_answers = $right_answers + 1
  else
    $wrong_answers += 1
  end

  if $right_answers + $wrong_answers == 4
    erb :results
  else
    redirect '/quiz'
  end
end
