require 'uri'
require 'net/http'
require 'openssl'
require 'json'

require './common_words_array'
require './dictionaries/definitions.rb'
key = 'bfa4039c-76b7-4bb8-bfe3-ddf63ae0769c'

word_array = []
bad_words = []


  search_definitions = Proc.new { |word|

  url = URI('https://www.dictionaryapi.com/api/v3/references/collegiate/json/' + word + '?key=' + key)



  http = Net::HTTP.new(url.host, url.port)
  http.use_ssl = true
  http.verify_mode = OpenSSL::SSL::VERIFY_NONE

  request = Net::HTTP::Post.new(url)

  response = http.request(request)
  parsed_json =  JSON.parse(response.body) # this will give an Array suddenly

  if parsed_json[0]['fl'].nil? || parsed_json[0]['shortdef'].nil?
    response_hash = parsed_json[1]
  else
    response_hash = parsed_json[0]
  end

  definition = response_hash['shortdef'][0]
  functional_label = response_hash['fl']

=begin
  sseq = response_hash['def'][0]['sseq']

  definition_1 = sseq.dig(0, 0, 1)
  if definition_1.class == Array
    definition = definition_1.dig(0, 1, 'dt', 0, 1)
  else
    definition = sseq.dig(0, 0, 1, 'dt', 0, 1)
  end

  if definition.nil?
    definition = sseq.dig(0, 0, 1, 'sense', 'dt', 0, 1)
  end

  if definition.nil?
    definition = sseq.dig(0, 0, 1, 0, 1, 'sense', 'dt', 0, 1)
  end

  unless definition.nil?
    definition.gsub!('{bc}','')
  end

  puts word
  # puts definition
=end
  if definition.nil?
    puts "Definition is nill"
    bad_words << word
  else
    puts word
  word_array << {'part' => functional_label}
  end
  }

second = $definitions[2601..2977]
a = 0
for i in second do
  search_definitions.call(i['word'])
  i['part'] = word_array[a]['part']
  a+=1
end



# print word_array
# print "bad words:"
print second
print bad_words