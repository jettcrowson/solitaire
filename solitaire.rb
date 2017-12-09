require "gosu"
require "./z_order"
require "./deck"
require "./positions"
require "./collumn"
require "./stack"

class Solitaire < Gosu::Window

      attr_accessor :deck, :collumns, :stacks, :clicked, :selected_cards, :draw_pile
    
      def initialize
        super(1920, 1080, :fullscreen => false)

        @background_image = Gosu::Image.new("images/background.jpg", tileable: true)

        #Gosu hides the cursor by default, so we have to add our own
        @cursor = Gosu::Image.new(self, "images/cursor.png")

        @deck = Deck.new()

        @collumns = []
        @stacks = []

        set_up

        @clicked = false
        @selected_cards = []

        @base_card_image = Gosu::Image.new("images/blank_card.png", tileable: true)

        @draw_pile = []
      end

      def set_up
        #Create the 7 collumns
        (1..7).each{ |num| collumns.push(Collumn.new(num))}

        #Create 4 stacks, one for each suit
        ["Hearts", "Diamonds", "Clubs", "Spades"].each_with_index{ |suit, i| stacks.push(Stack.new(suit, i))}
        
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

        #Flip the bottom card in each collumn
        collumns.each do |collumn|
          collumn.cards[-1].flip
        end

      end

      def check_click
        x = self.mouse_x
        y = self.mouse_y

        puts selected_cards

        #If you're holding nothing in your hand
        if selected_cards.length == 0

          check_draw_pile_click(x,y)
          select_collumn_section(x,y)
        
        #If you're holding one card
        elsif selected_cards.length == 1

          check_stack_click(x,y)

        #If you are holding more than one card
        else

        end
      end

      def check_stack_click(x,y)
        stacks.each do |stack|
          if x >= stack.x && x <= (stack.x + @base_card_image.width) && y >= stack.y && y <= (stack.y + @base_card_image.height)
            if selected_cards[0].val == stack.card_needed
              stack.add_card(selected_cards[0])
              
              collumns.each do |collumn|
                collumn.cards.delete(selected_cards[0])
              end

              deck.cards.delete(selected_cards[0])
              draw_pile.delete(selected_cards[0])

              self.selected_cards = []
            end
          end
        end
      end

      def check_draw_pile_click(x,y)
        
        #Check if the click was on the deck
        if x >= Position::Deck[0] && x <= (Position::Deck[0] + @base_card_image.width) && y >= Position::Deck[1] && y <= (Position::Deck[1] + @base_card_image.height)

          #Make sure there is a card to flip
          if deck.cards.length > 0

            #Add the card to the draw pile
            draw_pile.push(deck.top_card)

            #Move it over
            draw_pile[-1].x += @base_card_image.width + 25
            
            #Show it's face
            draw_pile[-1].flip

          #If there are no cards left to flip
          else
            
            #Add the draw pile to the deck
            deck.cards.concat(draw_pile)

            deck.cards.each do |card| 

              #Move it back over
              card.x -= (@base_card_image.width + 25)
              
              #Flip it back over
              card.flip

            end

            #Reset the draw pile
            self.draw_pile = []
          
          end

        end

      end

      def select_collumn_section(x, y)

        #Check each collumn
        collumns.each do |collumn|
          
          #Check the individual cards in each collumn
          collumn.cards.each_with_index do |card, i|
            
            #If it's the bottom card we can just select this
            if i == collumn.cards.length - 1

              #Check for collision of the entire bottom card
              if x >= card.x && x <= (card.x + @base_card_image.width) && y >= card.y && y <= (card.y + @base_card_image.height)
                
                #Push just the bottom card
                selected_cards.push(card)
              
              end
            
            else

              #If we are not on the bottom card and the click matches up with one of the 50px margins on a stacked card
              if x >= card.x && x <= (card.x + @base_card_image.width) && y >= card.y && y <= (card.y + 50)

                #Loop through the collumn
                collumn.cards.each_with_index do |c, i|

                  #If the card being checked is higher than the target card, skip it
                  if i <= (collumn.cards.index(card) - 1) then next end

                  #Add it if not
                  selected_cards.push(c)

                end

              end

            end

          end

        end
      end

      def update
        if selected_cards.length > 0
          selected_cards.each_with_index do |card, i|
            card.x = self.mouse_x
            card.y = self.mouse_y + (i * 50)
          end
        end

        collumns.each{ |collumn| collumn.update}
      end
    
      def draw
        @background_image.draw(0, 0, ZOrder::Background)
        @cursor.draw(self.mouse_x, self.mouse_y, ZOrder::Cursor)

        deck.draw
        collumns.each{ |col| col.draw}
        draw_pile.each{ |card| card.draw}
        stacks.each{ |stack| stack.draw}
      end
    
      #Close the program if the user presses Escape
      def button_down(id)
        close if id == Gosu::KbEscape

        if id == Gosu::MsLeft
          check_click
        end

      end
      
    end
    
    window = Solitaire.new
    window.show