#A collumn is one of the 7 stacks of cards on the bottom half of the screen
#This is where the main gameplay happens

class Collumn

    #Which collumn is it?
    attr_reader :number

    #Again, we'll constantly be changing the cards available
    attr_accessor :cards

    def initialize(number)
        @number = number

        @cards = []
    end

    def add_card(card)
        cards.push(card)
    end

    #Stack the cards in the collumn
    def stack_cards

        #Set each card in the collumn's position
        cards.each_with_index do |card, index|
            
            #Give all the cards the same x value but put each card slightly lower
            card.set_pos(Position::Collumn[number - 1][0], Position::Collumn[number - 1][1] + index * 50)
            
        end

    end

    def draw
        cards.each{ |card| card.draw}
    end

end