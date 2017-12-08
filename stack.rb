#A stack is one of the 4 piles of a single suit at the top of the screen
#To win the game you must fill each stack with all 13 of their cards

class Stack

    #Which suit is the stack for?
    attr_reader :suit

    attr_accessor :cards

    def initialize(suit)

        @suit = suit

        @cards = []

    end

    def add_card(card)
        cards.push(card)
    end

end