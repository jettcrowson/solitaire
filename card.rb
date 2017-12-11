#To be made 52 different times

require "./z_order"

class Card

    #These should not ever be changed, so we can just put a reader
    attr_reader :val, :suit, :color

    #These will constantly be changing so we need an accessor
    attr_accessor :x, :y, :val_text, :flipped, :default_x, :default_y

    def initialize(val, suit)

        #We will leave the value as a number until we print it
        #Ex: It will be a 1 instead of an Ace
        @val = val
        @suit = suit

        #Set the color according to suit
        @color = suit == "Hearts" || suit == "Diamonds" ? "red" : "black"

        @x = 100
        @y = 0

        @base_card_image = Gosu::Image.new("images/blank_card.png", tileable: true)
        @back_image = Gosu::Image.new("images/card_back.png", tileable: true)

        #Suit image will change automatically
        @suit_image = Gosu::Image.new("images/#{suit}.png", tileable: false)

        #For the numbering on the cards
        @font = Gosu::Font.new(45)

        #Change 1 to "A", 11 to "J", etc
        @val_text = set_val_text

        #Can you see the card yet?
        @flipped = false

        @default_x = 0

        @default_y = 0
    end

    def flip
        flipped ? self.flipped = false : self.flipped = true
    end

    def set_val_text
        case val
            when 1
                return "A"
            when 11
                return "J"
            when 12
                return "Q"
            when 13
                return "K"
            else
                return val
        end
    end

    #For changing the position of the card
    def set_pos(set_x, set_y)
        if default_x == 0 && default_y == 0
            self.default_x = set_x
            self.default_y = set_y
        end

        self.x = set_x
        self.y = set_y
    end

    def draw
        flipped ? draw_card_front : draw_card_back
    end

    def draw_card_front
        #To scale the suits
        scale = 0.15
        
        #Blank card
        @base_card_image.draw(x, y, ZOrder::Card)

        #Center the suit logo on the card
        @suit_image.draw(x + (@base_card_image.width / 2) -  (@suit_image.width / 2 * scale),
                         y + (@base_card_image.height / 2) -  (@suit_image.height / 2 * scale),
                         ZOrder::Card, scale, scale)

        #Draw the top left value in it's respective color
        @font.draw(val_text, 
                   x +  25, 
                   y + 25, ZOrder::Card, 1, 1, 
                   color == "red" ? 0xff_ff0000 : 0xff_000000)

        #Draw the bottom right value
        @font.draw(val_text, 
                   x +  @base_card_image.width - 55, 
                   y +  @base_card_image.height - 60, 
                   ZOrder::Card, 1, 1, 
                   color == "red" ? 0xff_ff0000 : 0xff_000000)
    end

    def draw_card_back
        @back_image.draw(x, y, ZOrder::Card)
    end

    #Instead of printing an object address, it will print somthing like "2 of Spades"
    def to_s
        return "#{val} of #{suit}"
    end


end
