=begin
  This program will generate MC (main character) with Background, Skills, Knowledge, and Traits
    Each category will have 3 chargen options: Random, Fully-Customized, and Guided (ie., some randomization w/ guidelines)
   => Background is taken from 6 separate countries
      All but 1 country has minimum requirements in other 
   => Skills is taken from 13 skills that can be modified at start
      10 of those skills begin with 25 points, other 3 begin with 0
      Skills are increased based on starter quiz - program should match quiz
      Some skills are mutually exclusive
   => Knowledge is taken from 8 fields, all starting at zero
   => Traits are personality traits - 13 options, some can be neutral, some not
=end

=begin
Verbs
  - Randomize
  - Select
Nouns
  - MC
  - Background
  - Skills
  - Knowledge
  - Traits
  - Questions
=end

module Selecting
  def random_or_custom(field)
    puts "Enter 'R' to randomize your #{field}. - Enter 'P' to select your own."
    input = ""
    loop do
      input = gets.strip
      input = input.downcase
      break if %w(r random randomize p pick).include?(input)
      puts "Enter 'R' to randomize, 'P' to pick your own."
    end
    input
  end

  def random?(input)
    %w(random r).include?(input)
  end

  def pick?(input)
    %w(pick p).include?(input)
  end

  def arland?
    country == "Arland"
  end

  def corval?
    country == "Corval"
  end

  def hise?
    country == "Hise"
  end

  def jiyel?
    country = "Jiyel"
  end

  def revaire?
    country = "Revaire"
  end

  def wellin?
    country = "Wellin"
  end
end

class Background
  include Selecting
  attr_reader :country

  COUNTRIES = %w(arland corval hise jiyel revaire wellin).map(&:capitalize)
  COUNTRIES_HASH = {}
  COUNTRIES.each { |country| COUNTRIES_HASH[country[0]] = country }
  COUNTRIES.freeze
  COUNTRIES_HASH.freeze

  def initialize
    get_name
    min_stats
  end

  def get_name
    result = random_or_custom("background")
    random if random?(result)
    pick if pick?(result)
  end

  def random
    @country = COUNTRIES.sample
  end

  def pick
    puts menu
    input = ""
    loop do
      input = gets.strip
      input = input.upcase
      break if keys.include?(input)
      puts "Enter the corresponding letter to pick your country."
    end
    @country = COUNTRIES_HASH[input]
  end

  def menu
    COUNTRIES.map { |country| instructions(country) }
  end

  def keys
    COUNTRIES_HASH.keys
  end

  def instructions(country)
    "Enter '#{country[0]}' for #{country}."
  end

  def min_stats
    arland_reqs if arland?
    corval_reqs if corval?
    jiyel_reqs if jiyel?
    revaire_reqs if revaire?
    wellin_reqs if wellin?
  end

  def corval_reqs
    @min_knowledge = {"Politics" => 50}
  end

  def jiyel_reqs
  end


end

class Character
  include Selecting

  def initialize
    @background = Background.new
    # @skills
    # @knowledge
    # @traits
  end
end

Character.new