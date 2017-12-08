require "gosu"
require "./z_order"
require "./deck"
require "./positions"
require "./collumn"
require "./stack"

class Solitaire < Gosu::Window

      attr_accessor :deck, :collumns, :stacks
    
      def initialize
        super(1920, 1080, :fullscreen => true)

        @background_image = Gosu::Image.new("images/background.jpg", tileable: true)

        #Gosu hides the cursor by default, so we have to add our own
        @cursor = Gosu::Image.new(self, "images/cursor.png")

        @deck = Deck.new()

        @collumns = []
        @stacks = []

        set_up
      end

      def set_up
        #Create the 7 collumns
        (1..7).each{ |num| collumns.push(Collumn.new(num))}

        #Create a stack for each suit
        ["Hearts", "Diamonds", "Clubs", "Spades"].each{ |suit| stacks.push(Stack.new(suit))}
        
        #Add the initial cards to each of the collumns
        collumns.each_with_index do |collumn, i|

          #Add 1 card to the first, 2 to the second, and so on
          (1..i + 1).each{ |num| collumn.add_card(deck.top_card)}
          
          #Set the positions of cards to match up with whatever collumn they're in
          collumn.stack_cards

        end

        #Position the deck
        deck.cards.each do |card|

          card.set_pos(Position::Deck[0], Position::Deck[1])
      
        end

      end

      def update

      end
    
      def draw
        @background_image.draw(0, 0, ZOrder::Background)
        @cursor.draw(self.mouse_x, self.mouse_y, ZOrder::Cursor)

        deck.draw
        collumns.each{ |col| col.draw}
      end
    
      #Close the program if the user presses Escape
      def button_down(id)
        close if id == Gosu::KbEscape
      end
      
    end
    
    window = Solitaire.new
    window.show