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
  attr_accessor :required

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

class ArlandPrincess
end

class CorvalLady
end

class HisePirate
end

class JiyelScholar
end

class RevaireWidow
end

class WellinCountess
end


class Character
  attr_reader :background

  def initialize
    @background = Background.new
    @stats = base_stats
  end

  def base_stats
    return ArlandPrincess.new if arland?
    return CorvalLady.new if corval?
    return HisePirate.new if hise?
    return JiyelScholar.new if jiyel?
    return RevaireWidow.new if revaire?
    WellinCountess.new if wellin?
  end

  def arland?
    background.country == "Arland"
  end

  def corval?
    background.country == "Corval"
  end

  def hise?
    background.country == "Hise"
  end

  def jiyel?
    background.country == "Jiyel"
  end

  def revaire?
    background.country == "Revaire"
  end

  def wellin?
    background.country == "Wellin"
  end
end

Character.new