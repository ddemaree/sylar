module Practical
  class PasswordGenerator
    WORD_LIST = %w(apple adam allyson auburn beach bobby bonnie blue catwalk charles caroline chartreuse duck david deirdre denim eagle edward emily eggplant fireball frederick fiona fuchsia grapefruit gregory ginnifer gamboge hardwood howard hailey heather ironclad ira irene indigo javelin joseph jadzia jade keyhole kenneth katrin khaki loophole leonard libbets lemon maypole michael marissa mocha neighbor neil nella navy optical olaf oprah orange porthole peter patricia purple question quention quin rosebud roberto rosalyn rust sinkhole stephen sarah sepia truthiness thomas taylor taupe underworld ulysses uma ultramarine venture victor violet vermillion weather william whitney wisteria xerox xavier xenia yelp yaphet yasmin yellow)

    # class << self
    #   def generate
    #     %{#{WORD_LIST[rand(WORD_LIST.length)]}#{rand(99)}#{WORD_LIST[rand(WORD_LIST.length)]}}
    #   end
    # end
    
    def self.humane
      password  = ""
      password += WORD_LIST[rand(WORD_LIST.length)]
      password += rand(99).to_s
      password += WORD_LIST[rand(WORD_LIST.length)]
      password
    end
    
    def self.mixed
      feedbag  = seed_alphanumerals
      password  = ""
      password += WORD_LIST[rand(WORD_LIST.length)]
      
      5.times do
        password += feedbag[rand(feedbag.length)].to_s
      end
      
      password
    end
    
    def self.random(length=8)
      feedbag  = seed_alphanumerals
      password = ""
      
      length.times do
        password += feedbag[rand(feedbag.length)].to_s
      end
      
      password
    end
    
  protected
  
    def self.seed_alphanumerals
      feedbag  = []
      feedbag += (0..9).collect
      feedbag += ('A'..'Z').collect
      feedbag += ('a'..'z').collect
      feedbag
    end
  end
end