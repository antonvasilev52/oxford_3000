require 'uri'
require 'net/http'
require 'openssl'
require 'json'

require './common_words_array'
key = '30308584-7bd9-4abf-8cf9-24acf3bc864a'

word_array = []
bad_words = []


  search_definitions = proc { |word|

  url = URI('https://www.dictionaryapi.com/api/v3/references/thesaurus/json/' + word + '?key=' + key)



  http = Net::HTTP.new(url.host, url.port)
  http.use_ssl = true
  http.verify_mode = OpenSSL::SSL::VERIFY_NONE

  request = Net::HTTP::Post.new(url)

  response = http.request(request)
  parsed_json =  JSON.parse(response.body) # this will give an Array suddenly

  response_hash = parsed_json[0]

  functional_label = response_hash['fl']
  response = response_hash['def']

  if response.nil?
    puts "#{word}: no word"
    bad_words << word
    else
  definition = response_hash['def'][0]['sseq'][0][0][1]['dt']
  end

  if definition.nil?
    puts "#{word}: no examples"
    bad_words << word
  elsif response_hash['def'][0]['sseq'][0][0][1]['dt'].length < 2
    puts "#{word}: no vis"
    bad_words << word
  else
    puts word
    definition = definition[1][1][0]['t']
    beauty_definition = definition.gsub(/{it}.*{\/it}/, "(#{functional_label})")
    full_definition = definition.gsub(/{\/it}/, '').gsub(/{it}/, '')
    # full_definition = full_definition.gsub(/{it}/, '')
    word_array << {'word' => word, 'part' => functional_label, 'definition' => beauty_definition, 'full_definition' => full_definition}
  end
  }

second = $oxford[201..400] # take N..M first words from Oxford 3000

for i in second do
  search_definitions.call(i)
end

print word_array
print 'bad words:'
print bad_words