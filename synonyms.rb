require 'uri'
require 'net/http'
require 'openssl'
require 'json'

require './common_words_array'
require './dictionaries/thesaurus_synonyms.rb'
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

  definition = response_hash
  functional_label = response_hash['fl']


  if definition.nil?
    puts "#{word}: definition is nill"
    bad_words << word
  else
    puts word
    word_array << {'part' => functional_label}
  end
  }

second = $thesaurus_synonyms[2601..2855]
a = 0
for i in second do
  search_definitions.call(i['word'])
  i['part'] = word_array[a]['part']
  a+=1
end

print second
print "bad words:"
print bad_words