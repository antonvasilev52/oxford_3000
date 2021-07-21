require 'uri'
require 'net/http'
require 'openssl'
require 'json'

require './common_words_array'
key = '30308584-7bd9-4abf-8cf9-24acf3bc864a'

word_array = []
bad_words = []


  search_definitions = Proc.new { |word|

  url = URI('https://www.dictionaryapi.com/api/v3/references/thesaurus/json/' + word + '?key=' + key)



  http = Net::HTTP.new(url.host, url.port)
  http.use_ssl = true
  http.verify_mode = OpenSSL::SSL::VERIFY_NONE

  request = Net::HTTP::Post.new(url)

  response = http.request(request)
  parsed_json =  JSON.parse(response.body) # this will give an Array suddenly

  response_hash = parsed_json[0]

  definition = response_hash['meta']


  if definition.nil?
    puts "#{word}: No synonyms or word"
    bad_words << word
  else
    puts word
  word_array << {'word' => word, 'definition' => definition['syns'][0][0]}
  end
  }

second = $oxford[1101..1300]

for i in second do
  search_definitions.call(i)
end

print word_array
print "bad words:"
print bad_words