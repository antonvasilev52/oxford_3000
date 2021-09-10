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
if parsed_json[0]['fl'].nil? || parsed_json[0]['shortdef'].nil?
  response_hash = parsed_json[1]
else
  response_hash = parsed_json[0]
end

  functional_label = response_hash['fl']

bad_words = []
  #  definition = response_hash['def'][0]['sseq'][0][0][1]['dt'][1][1][0]['t']
  definition = response_hash['shortdef'][0]
if definition.nil?
  bad_words << word
else
 puts word
 puts definition
 word_array << {'word' => word, 'part' => functional_label, 'definition' => definition}
end



puts word_array
print "bad words:"
print bad_words