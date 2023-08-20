require 'colorize'
@menu = {water: 1.8,apple: 3.2,sugar: 5.75, bread: 2.8}
@discount_code = {TENPERCENT: 0.1,TWENTYPERCENT: 0.2,FIFTYPERCENT: 0.5}

def main()
	loop do
	new_customer()
	puts "Enter 'y' for next customer.".green
	restart = gets.chomp.downcase
	break if restart != 'y'
	end
end

def new_customer()
	set_default()	
	get_name()
	add_to_basket()
	discount()
	checkout()
	payment()
end

def set_default()
	@total = 0
	@basket_qty = {}
	@basket_price = {}
end

def get_name()
	puts "Welcome to Baratas Supermarket".green
	puts "Please enter your name".green
	@customer_name = gets.chomp.upcase
end

def add_to_basket()
	loop do
		puts "Hi #{@customer_name}. Please key in your item".green
		@item = gets.chomp.downcase
		calculator()
		puts "Enter 'y' if you would like to continue adding items".green
		@continue_adding = gets.chomp.downcase
		break if @continue_adding != 'y'
	end
end

def calculator()
	if @menu.has_key?(:"#{@item}")
		puts "How many #{@item}(s) would you liked to purchase?".green
		@qty = gets.to_f
		update_basket()		
		@total += @menu[:"#{@item}"] * @qty
		puts "Current total is RM #{sprintf('%.2f', @total)}".green
	else
		puts "Invalid item. Please key in again".red
	end
end

def update_basket()
	if @basket_qty[@item] == nil
		#@basket_qty[@item] = [@qty, @menu[:"#{@item}"] * @qty]
		@basket_qty[@item] = @qty
		@basket_price[@item] = @menu[:"#{@item}"] * @qty
	else
		#@basket_qty[@item] = [@qty + @basket_qty[@item], @menu[:"#{@item}"] * @qty + @basket_price[@item]]
		@basket_qty[@item] = @qty + @basket_qty[@item]
		@basket_price[@item] = @menu[:"#{@item}"] * @qty + @basket_price[@item]
	end
	puts "#{sprintf('%.0f',@qty)} #{@item}(s) added to shopping basket.".green 
	print_receipt()
end

def print_receipt()
	#puts "Item     Qty     Price".blue
	puts "Item           Price".blue
	#@basket_qty.each do |item, qty, price|
		#puts "#{item} x #{sprintf('%.0f',qty)} = #{sprintf('%.2f',price)}".yellow
		#puts "#{item} x #{qty} = #{price}".yellow
	@basket_price.each do |item, price|
		puts "#{item}          RM#{sprintf('%.2f',price)}".yellow
	end
end

def discount()
	loop do
		puts "Please enter a valid discount code or type 'X' to skip".green
		@input_code = gets.chomp.upcase
		@val = 0
		break if @input_code == "X"
		#puts @discount_code.key?:"#{@input_code}"
		if @discount_code.has_key?(:"#{@input_code}")
			@val = @discount_code[:"#{@input_code}"]
			puts "#{@val*100}% discount has been applied".green
			return @val
		else
			puts "Invalid discount code.".red
		end
	end
end

def checkout()
	loop do
	puts "Enter 'A' to continue adding items".green
	puts "Enter 'B' to proceed to payment".green
	proceed = gets.chomp.upcase
		if proceed == "A"
			add_to_basket()
		elsif proceed == "B"
			break
		else
			puts "Invalid response"
		end
	end
end

def payment()
	@total_after_discount = @total * (1-@val)
	print_receipt()
	puts "#{@val*100}% discount has been applied".green
	puts "Final amount to be paid is RM#{sprintf('%.2f',@total_after_discount)}".green
	puts "Please enter the amount to be paid".green
	loop do
		payment = gets.to_f
		change = 0
		if payment >= @total_after_discount
			change = payment - @total_after_discount
			puts "Your change is RM#{sprintf('%.2f',change)}.".green
			puts "Thank you for shopping with Baratas Supermarket".green
		else
			puts "Insufficient amount. Please enter again".red
		end
		break if payment >= @total_after_discount
	end
end

puts main()