#A stack is one of the 4 piles of a single suit at the top of the screen
#To win the game you must fill each stack with all 13 of their cards

require "./positions"

class Stack

    #Which suit is the stack for?
    attr_reader :suit

    attr_accessor :cards, :x, :y

    def initialize(suit, num)

        @suit = suit

        @cards = []

        @base_image = Gosu::Image.new("images/card_outline.png", tileable: true)

        @x = Position::Stack[num][0]
        @y = Position::Stack[num][1]
    end

    def draw
        @base_image.draw(x, y, ZOrder::Deck)

                #Set each card in the collumn's position
                cards.each_with_index do |card, index|
                    
                    #Give all the cards the same x value but put each card slightly lower
                    card.set_pos(Position::Collumn[number - 1][0], Position::Collumn[number - 1][1] + index * 50)
                    
                end
    end

    def add_card(card)
        cards.push(card)
    end

end