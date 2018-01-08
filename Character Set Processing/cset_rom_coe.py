cgrom_file = open("cgrom.bin", "rb")
coe_file = open("rom.coe", "wb")

coe_file.write("memory_initialization_radix=10;\nmemory_initialization_vector=\n")

i = 0
j = 0

#  _
# |
character_1 =  [0b11111111,
				0b10000000,
				0b10000000,
				0b10000000,
				0b10000000,
				0b10000000,
				0b10000000,
				0b10000000]

#  _
#   |
character_2 =  [0b11111111,
				0b00000001,
				0b00000001,
				0b00000001,
				0b00000001,
				0b00000001,
				0b00000001,
				0b00000001]
				
#  |
#  _
character_3 =  [0b00000000,
				0b10000000,
				0b10000000,
				0b10000000,
				0b10000000,
				0b10000000,
				0b10000000,
				0b11111111]
				
#  |
# _
character_4 =  [0b00000001,
				0b00000001,
				0b00000001,
				0b00000001,
				0b00000001,
				0b00000001,
				0b00000001,
				0b11111111]

#  |
character_5 =  [0b00000001,
				0b00000001,
				0b00000001,
				0b00000001,
				0b00000001,
				0b00000001,
				0b00000001,
				0b00000001]
				
# |
character_6 =  [0b10000000,
				0b10000000,
				0b10000000,
				0b10000000,
				0b10000000,
				0b10000000,
				0b10000000,
				0b10000000]
				
# _
character_7 =  [0b11111111,
				0b00000000,
				0b00000000,
				0b00000000,
				0b00000000,
				0b00000000,
				0b00000000,
				0b00000000]
				
# _
character_8 =  [0b00000000,
				0b00000000,
				0b00000000,
				0b00000000,
				0b00000000,
				0b00000000,
				0b00000000,
				0b11111111]

character = [character_1,character_2,character_3,character_4,character_5,character_6,character_7,character_8]

character_array = cgrom_file.read()
character_array = character_array + "\x00"

for n in character:
	for m in n:
		coe_file.write(str(m) + ",\n")
	i = i + 1

while i < 128:
	if (ord(character_array[j]) == i):
		for n in range(1,9):
			coe_file.write(str(ord(character_array[j+n])<<3) + ",\n")
		j = j + 9
	else:
		for n in range(1,9):
			coe_file.write("0,\n")
	i = i + 1

cgrom_file.close()
coe_file.close()