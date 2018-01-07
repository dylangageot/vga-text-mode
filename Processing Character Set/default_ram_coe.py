coe_file = open("ram.coe", "wb")
coe_file.write("memory_initialization_radix=10;\nmemory_initialization_vector=\n")

j = 0
text = "Hello world !"

for i in text:
	coe_file.write(str(ord(i)) + ",\n")
	j = j + 1

while j < 4800:
		
	coe_file.write(str(ord(' ')) + ",\n")
	j = j + 1

coe_file.close()