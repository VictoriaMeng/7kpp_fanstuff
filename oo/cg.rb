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
  end

  def to_s
    country
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
end

class Stat
  attr_reader :name

  def initialize(name)
    @name = name
  end
end

class Skill < Stat
  SKILLS = %w(Charm Eloquence Beauty Leadership Self-Defense Charisma Manipulation Courage Intelligence Etiquette Grace Poise Cunning)
  SKILLS.each { |skill| skill.gsub!("-", " ") }.freeze

  def initialize(name)
    super
    @score = start_score_zero?(name) ? 0 : 25
  end

  def start_score_zero?(name)
    ["Self Defense", "Manipulation", "Cunning"].include?(name)
  end
end 

class Knowledge < Stat
  SUBJECTS = %w(History Politics Street-Smarts Warfare Practical Academic People Flora-and-Fauna)
  SUBJECTS.each { |subject| subject.gsub!("-", " ") }.freeze

  def initialize(name)
    super
    @value = 0
  end
end

class Trait < Stat
  def initialize(name)
    @value = 0
  end
end

class Character
  def initialize
    base_skills
    base_knowledge
  end

  def base_skills
    @skills = {}
    Skill::SKILLS.each { |skill| @skills[skill] = Skill.new(skill) }
  end

  def base_knowledge
    @knowledge = {}
    Knowledge::SUBJECTS.each { |subject| @knowledge[subject] = Knowledge.new(subject) }
  end
end

class ArlandPrincess < Character
  def initialize
    super
    @role = "Sheltered Princess"
  end
end

class CorvalLady < Character
  def initialize
    super
    @role = "Court Lady"
  end
end

class HisePirate < Character
  def initialize
    super
    @role = "Pirate Captain"
  end
end

class JiyelScholar < Character
  def initialize
    super 
    @role = "Minor Scholar"
  end
end

class RevaireWidow < Character
  def initialize
    super
    @role = "Ambitious Widow"
  end
end

class WellinCountess < Character
  def initialize
    super
    @role = "Tomboy Countess"
  end
end

class Generator
  attr_reader :background

  def initialize
    @background = Background.new
    @character = character
  end

  def country
    background.country
  end

  def character
    return ArlandPrincess.new if arland?
    return CorvalLady.new if corval?
    return HisePirate.new if hise?
    return JiyelScholar.new if jiyel?
    return RevaireWidow.new if revaire?
    WellinCountess.new if wellin?
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
    country == "Jiyel"
  end

  def revaire?
    country == "Revaire"
  end

  def wellin?
    country == "Wellin"
  end
end

Generator.new