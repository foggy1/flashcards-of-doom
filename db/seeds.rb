#Faker::Internet.user_name
# password: doom
# Faker::Internet.safe_email
# deck titles Faker::Pokemon.name #=> "Pikachu"
# questions Faker::StarWars.quote
# answer Faker::Color.color_name

10.times { User.create(username: Faker::Internet.user_name,
                       email: Faker::Internet.safe_email,
                       password: 'doom')
          }

3.times { Deck.create(title: Faker::Pokemon.name) }

Deck.all.each do |deck|
  deck.cards = Array.new(8) { Card.create(question: Faker::StarWars.quote,
                                          answer: Faker::Color.color_name)
                            }
end

