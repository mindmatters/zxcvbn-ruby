require 'json'
require 'zxcvbn/dictionary_ranker'

module Zxcvbn
  class Data
    def initialize(languages)
      @languages = languages
      @ranked_dictionaries = DictionaryRanker.rank_dictionaries(
        "words" =>        read_word_lists("words.txt"),
        "female_names" => read_word_lists("female_names.txt"),
        "male_names" =>   read_word_lists("male_names.txt"),
        "passwords" =>    read_word_lists("passwords.txt"),
        "surnames" =>     read_word_lists("surnames.txt")
      )
      @adjacency_graphs = JSON.load(DATA_PATH.join('adjacency_graphs.json').read)
    end

    attr_reader :ranked_dictionaries, :adjacency_graphs

    def add_word_list(name, list)
      @ranked_dictionaries[name] = DictionaryRanker.rank_dictionary(list)
    end

    private

    def read_word_lists(file)
      word_lists = @languages.map do |language|
        read_word_list(file, language)
      end
      word_lists[0].zip(*word_lists[1..-1]).flatten.compact
    end

    def read_word_list(file, language)
      filename = DATA_PATH.join("frequency_lists", language, file)
      File.file?(filename) ? filename.read.split : []
    end
  end
end
