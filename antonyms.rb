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

  definition = response_hash


  if definition['meta'].nil?
    puts "#{word}: no meta"
    bad_words << word
  elsif definition['meta']['ants'].length == 0
    puts "#{word}: ants empty"
    #    definition = response_hash['def'][0]['sseq'][0][0][1]['near_list'][0][0]['wd']
    bad_words << word
    # word_array << {'word' => word, 'definition' => definition}
  else
    puts word
  word_array << {'word' => word, 'definition' => definition['meta']['ants'][0][0]}
  end
  }

second = $oxford[21..100] # скопировал до 20

for i in second do
  search_definitions.call(i)
end

print word_array
print "bad words:"
print bad_words