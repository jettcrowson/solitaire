#A stack is one of the 4 piles of a single suit at the top of the screen
#To win the game you must fill each stack with all 13 of their cards

require "./positions"

class Stack

    #Which suit is the stack for?
    attr_reader :suit,  :num

    attr_accessor :cards, :x, :y, :card_needed

    def initialize(suit, num)

        @suit = suit

        @num = num

        @cards = []

        @base_image = Gosu::Image.new("images/card_outline.png", tileable: true)

        @x = Position::Stack[num][0]
        @y = Position::Stack[num][1]

        @card_needed = 1
    end

    def draw
        @base_image.draw(x, y, ZOrder::Deck)

        cards.each{ |card| card.draw}

    end

    def add_card(card)
        card.set_pos(Position::Stack[num][0], Position::Stack[num][1])
        cards.push(card)
        self.card_needed += 1
    end

end