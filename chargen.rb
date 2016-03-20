def format_array(array)
  array.sort.map { |string| string.split("-").map { | word | word == "and" ? word : word.capitalize }.join(" ") }
end

def format_hash(hash)
  values = hash.values.map { | array | format_array(array) }
  hash.each do | block, subjects |
    hash[block] = values.shift
  end
  hash
end

BACKGROUNDS = format_array(%w(arland corval hise jiyel revaire wellin))

BACKGROUNDS_SHORT = %w(a c h j r w)

SKILLS = format_array(%w(beauty intelligence charisma charm leadership courage cunning manipulation eloquence etiquette self-defense poise grace))

FLAWS = format_array(%w(beauty intelligence charisma charm leadership courage eloquence grace))

KNOWLEDGE = format_hash( {  1 => %w(history politics warfare academics),
                            2 => %w(street-smarts practical people flora-and-fauna),
                            3 => %w(history politics practical academics)             }  )

APPROVAL = format_array(%w(commoners merchants artists arland-court))

TRAITS = format_hash(  {  empathy: %w(compassionate indifferent),
                          idealism: %w(cynical romantic),
                          honesty: %w(subtle overt),
                          independence: %w(dependent autonomous),
                          ambition: %w(ambitious unassuming),
                          altruism: %w(noble selfish),
                          imagination: %w(sensible imaginative),
                          traditionalism: %w(traditional innovative),
                          work_style: %w(spontaneous methodical),
                          interaction_style: %w(introverted social),
                          rationality: %w(logical emotional),
                          ethics: %w(immoral ethical)                  }  )

BACKGROUND_METHODS = ["Enter 'P' to choose your background.", "Enter 'R' for a random background."]

BACKGROUND_MENU = [  "Enter 'A' for Arland.",
                     "Enter 'C' for Corval.",
                     "Enter 'H' for Hise.",
                     "Enter 'J' for Jiyel.",
                     "Enter 'R' for Revaire.",
                     "Enter 'W' for Wellin."    ]

BACKGROUND_KEYS = {}

BACKGROUNDS.each do | background |
  BACKGROUNDS_SHORT.each do | letter |
    BACKGROUND_KEYS[letter] = background if BACKGROUNDS.index(background) == BACKGROUNDS_SHORT.index(letter)
  end
end

def template_corval(mc)
  block = KNOWLEDGE.select { | block, subject | subject.include?("Politics") }.keys.sample
  mc[:knowledge][block] = "Politics"
  mc[:traits][:ambition] = "Ambitious"
end

def template_jiyel(mc)
  mc[:strengths] = %w(Intelligence)
  mc[:traits][:rationality] = "Logical"
end

def template_hise(mc)
  mc[:traits][:traditionalism] = "Innovative"
end

def template_revaire(mc)
  mc[:traits][:ambition] = "Ambitious"
end

def template_wellin(mc)
  mc[:strengths] = format_array(%w(self-defense courage))
  mc[:knowledge][1] = "Warfare"
  mc[:traits][:traditionalism] = "Innovative"
  mc[:banned_strengths] = format_array(%w(manipulation))
end

def template_arland(mc)
  mc[:approval] = "Arland Court"
  mc[:strengths] = %w(Etiquette)
  mc[:traits][:independence] = "Dependent"
  mc[:banned_strengths] = format_array(%w(self-defense courage manipulation cunning))
  mc[:banned_knowledge] = format_array(%w(warfare street-smarts))
  mc[:banned_traits] = {idealism: "Cynical", honesty: "Overt", ambition: "Ambitious"}
end

def set_background_templates(mc)
  case mc[:background]
  when "Corval"
    template_corval(mc)
  when "Jiyel"
    template_jiyel(mc)
  when "Revaire"
    template_revaire(mc)
  when "Wellin"
    template_wellin(mc)
  when "Arland"
    template_arland(mc)
  else
    template_hise(mc)
  end
end

def invalid_option?(item, banned_field)
  banned_field.include?(item)
end

def exclusive_strengths(mc, strength, banned_strength)
  mc[:banned_strengths] << banned_strength if strength
end

def randomize_approval(mc)
  mc[:approval] = APPROVAL.sample if mc[:background] != "Arland"
end

def randomize_background(mc)
  mc[:background] = BACKGROUNDS.sample
  set_background_templates(mc)
end

def randomize_flaws(mc)
  2.times do
    begin
      flaw = FLAWS.sample
    end while invalid_option?(flaw, mc[:banned_flaws]) 
    mc[:flaws] << flaw
  end
end

def randomize_strengths(mc)
  new_strengths = 0 
  until new_strengths == 5
    begin
      strength = SKILLS.sample
    exclusive_strengths(mc, "Grace", "Poise")
    exclusive_strengths(mc, "Poise", "Grace")
    end while invalid_option?(strength, mc[:banned_strengths]) || mc[:strengths].include?(strength)
    mc[:strengths] << strength
    new_strengths += 1
  end
end

def randomize_knowledge(mc)
  KNOWLEDGE.each do | block, subjects |
    begin 
      subject = subjects.sample
    end while invalid_option?(subject, mc[:banned_knowledge])
      mc[:knowledge][block] = subject if !mc[:knowledge].key?(block)
  end
end

def randomize_traits(mc)
  TRAITS.each do | trait, adjectives |
    begin 
      adjective = adjectives.sample
    end while mc[:banned_traits].value?(adjective)
      mc[:traits][trait] = adjective if !mc[:traits].key?(trait)
  end
end

def randomize_full_mc(mc)
  randomize_background(mc)
  randomize_approval(mc)
  randomize_flaws(mc)
  randomize_strengths(mc)
  randomize_knowledge(mc)
  randomize_traits(mc)
end

def show_profile(mc)
  puts "Background: #{mc[:background]}"
  puts "Strengths: #{mc[:strengths]}"
  puts "Approval: #{mc[:approval]}"
  puts "Weaknessess: #{mc[:flaws]}"
  puts "Knowledge: #{mc[:knowledge].values}"
  puts "Traits: #{mc[:traits].values}"
end

def list_options(list)
  list.each { | item | puts "- #{item}" }
end

def correct_input?(input, input_array)
  input_array.include?(input.downcase)
end

def get_background_input
  begin
    list_options(BACKGROUND_MENU)
    input = gets.chomp
  end until correct_input?(input, %w(a c h j r w))
  input.downcase
end

def match_background_input(mc, input)
  mc[:background] = BACKGROUND_KEYS[input]
end

def choose_background(mc)
  input = get_background_input
  match_background_input(mc, input)
  set_background_templates(mc)
end

def background_method(mc, input)
  choose_background(mc) if input == "p"
  randomize_full_mc(mc) if input == "r"
end

puts "Welcome to Mimi's MC Generator! - Would you like a random background, or to pick your own?"
begin
  list_options(BACKGROUND_METHODS)
  input = gets.chomp
end until correct_input?(input, %w(p r))
input = input.downcase

mc = {  strengths: [],
        flaws: [],
        knowledge: {},
        traits: {},
        banned_strengths: [],
        banned_flaws: ["Charisma"],
        banned_knowledge: [],
        banned_traits: {}      }

background_method(mc, input)
show_profile(mc)










