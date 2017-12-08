require "./card"

#After the initial distribution, the deck will be the draw pile
class Deck

    #We will need to be taking cards out of the deck to add them to different collumns or the final stacks
    attr_accessor :cards

    def initialize
        suits = ["Hearts", "Diamonds", "Spades", "Clubs"]

        @cards = []

        #For each suit, create 13 cards
        suits.each do |suit|
            (1..13).each do |val|
                cards.push(Card.new(val, suit))
            end
        end

        #Mix up the deck
        self.cards = cards.shuffle
    end

    #Return a card and remove it from the deck so there are not duplicates
    def top_card
        return cards.shift
    end

    def draw
        cards.each{ |card| card.draw}
    end

end
