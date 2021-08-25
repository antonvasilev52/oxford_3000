require 'uri'
require 'net/http'
require 'openssl'
require 'json'
word = gets.chomp
key = '30308584-7bd9-4abf-8cf9-24acf3bc864a'

word_array = []

 url = URI('https://www.dictionaryapi.com/api/v3/references/thesaurus/json/' + word + '?key=' + key)

  http = Net::HTTP.new(url.host, url.port)
  http.use_ssl = true
  http.verify_mode = OpenSSL::SSL::VERIFY_NONE

  request = Net::HTTP::Post.new(url)

  response = http.request(request)
  parsed_json =  JSON.parse(response.body) # this will give an Array suddenly

  #puts parsed_json
  response_hash = parsed_json[0]
  functional_label = response_hash['fl']

bad_words = []
  definition = response_hash['def'][0]['sseq'][0][0][1]['dt'][1][1][0]['t']
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