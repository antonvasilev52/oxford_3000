require 'uri'
require 'net/http'
require 'openssl'
require 'json'
word = gets.chomp
key = 'bfa4039c-76b7-4bb8-bfe3-ddf63ae0769c'

word_array = []

 url = URI('https://www.dictionaryapi.com/api/v3/references/collegiate/json/' + word + '?key=' + key)

  http = Net::HTTP.new(url.host, url.port)
  http.use_ssl = true
  http.verify_mode = OpenSSL::SSL::VERIFY_NONE

  request = Net::HTTP::Post.new(url)

  response = http.request(request)
  parsed_json =  JSON.parse(response.body) # this will give an Array suddenly

  #puts parsed_json
  response_hash = parsed_json[0]

  sseq = response_hash['def'][0]['sseq']
  definition_1 = sseq.dig(0, 0, 1)
  if definition_1.class == Array
  definition = definition_1.dig(0, 1, 'dt', 0, 1)
  end


  puts word
  puts definition

  word_array << {'word' => word, 'definition' => definition}

puts word_array