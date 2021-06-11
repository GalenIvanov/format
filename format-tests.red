Red[
    Title: "format tests"
]

do %format.red

print format {My name is {name|center 10x0 #"_"}. I'm {age | fixed 7x2} years old.}[age: 36.345 name: "John"]
print format {The price is USD {price|sep 25 #"," #"*"}.}[price: 1234502342.67]
print format {There are {weight |sci 10x3} kilograms of cotton}[weight: 0.8546]
print format {There are {planets |sci 12x2 #"0"} planets in the Solar system}[planets: 8]
print format {There are {planets |sci 15x4 #"#"} planets in the Milky Way}compose [planets: (10.0 ** 9 * 400)]
print format {15 is {val| base 2 10x8 #" " on}}[val: 15]
print format {12423427 is {val| base 16 15x8 #"=" on}}[val: 12423427]
print format {12423427.56 is {val| base 8 15x8 #"0"}}[val: 12423427.56]
print format {Today is {day | dd-mm-yyyy #"/"}}compose[day: (now)]
print format {Today is {day | yyyy-mm-dd}}compose[day: (now)]
print format {Today is {day | yyyy-ww-ddd}}compose[day: (now)]
print format {Today is {day | yyyy-ddd #"#"}}compose[day: (now)]