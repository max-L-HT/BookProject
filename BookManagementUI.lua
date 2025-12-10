Book = {title = "",author = "", year = "", checked_out = false}
bookshelf = {}
local csvfile = io.open("table.csv","r")


function Book:new(title,author,year)
	book= {}
	self.__index = self
	setmetatable(book,self)
	book.title = title or "Test Title"
	book.author = author or "Test Author"
	book.year = year or 9999
	return book
end

function bookshelf:create(title,author,year)
	local temp = Book:new(title,author,year)
	table.insert(bookshelf,temp)
	return temp
end
for line in csvfile:lines() do
	split1=string.find(line,",")
	split2=string.find(line,",",split1+1)
	split3=string.find(line,",",split2+1)
	local bookname=string.sub(line,0,split1-1)
	local bookauthor = string.sub(line,split1+1,split2-1)
	local bookdate=string.sub(line,split2+1,split3)
	bookshelf:create(bookname,bookauthor,bookdate)
end

function bookshelf:read(index)
	found_book = bookshelf[index]
	return found_book
end

function bookshelf:update(index,property,new_data)
	bookshelf[index][property]=new_data
end
function bookshelf:find(property, value)
	for index,book in pairs(self) do
		if string.match(book[property], value)~=nil then
			return book.title,", written by ",book.author,", released in ",book.year
		end
	end
end

function ui()
	io.write("What would you like to do? [C]reate book, [S]earch book, [U]pdate book, or [q]uit")
	local input = io.read()
	if input == "C" then
		io.write("What would you like the title to be? ")
		local newtitle = io.read()
		io.write("What would you like the author to be? ")
		local newauthor = io.read()
		io.write("When did the book release? ")
		local newyear = io.read()
		bookshelf:create(newtitle,newauthor,newyear)
	elseif input == "S" then
		io.write("Would you like to search for [title], [author], or [year]")
		local taoy = io.read()
		if taoy ~= "title" and taoy ~= "author" and taoy ~= "year" then
			io.write("Please select a valid option, better luck next time")
		else
			io.write("Please write the ",taoy)
			taoy2 = io.read()
			io.write(bookshelf:find(taoy,taoy2))
		end
	elseif input == "U" then
		for i,books in pairs(bookshelf) do
			if type(books) == "table" then
				io.write(i," ",books.title," by ",books.author," (",books.year,")\n")
			end
		end
		io.write("\nEnter the number of the book you want to update: ")
		local num_book = tonumber(io.read())
		io.write("Enter if you want to change [title], [author], or [year]: ")
		local valuechange = io.read()
		io.write("Write what you want to change it to: ")
		local new_d = io.read()
		for i,books in pairs(bookshelf) do
			if type(books) == "table" then
				if i == num_book then
					bookshelf:update(num_book,valuechange,new_d)
				end
			end
		end
	elseif input == "q" then
		os.exit()	
	
	end
end
while true do
	ui()
	io.write("\n")
end
