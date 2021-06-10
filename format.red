Red [
    Title:  "String formatting, similar to Python's format()" 
    Author: "Galen Ivanov"

]


; alignment: left / right / center ; width x trim ; [padding]
; thousand separator:  
; fix point 

; base conversions
; decimal
; scientific format e/E
; percentage
; dates: ddmmyyyy ddmmmyyyy yyyymmdd yyyyddd yyyyw 


context [
 
    left: function[
        {Left aligns the text, truncated to amount/y chars (0 means no change).
        Pads to amount/x chars to the right using fill} 
        text   
        amount [pair!]
        fill   [char!]
    ][
        text: form text
        if zero? amount/y[amount/y: length? text]
        pad/with take/part text amount/y amount/x fill
    ]
    
    right: function[
        {Right aligns the text, truncated to amount/y chars (means is no change).
        Pads to amount/x chars to the left using fill} 
        text  
        amount [pair!]
        fill   [char!]
    ][
        text: form text
        if zero? amount/y[amount/y: length? text]
        pad/left/with take/part text amount/y amount/x fill
    ]
    
    center: function[
        {Centers the text, truncated to amount/y chars (0 means no change).
        Pads to amount/x chars to the left and right using fill} 
        text   
        amount [pair!]
        fill   [char!]
    ][
        text: form text
        if zero? amount/y[amount/y: length? text]
        text: take/part text amount/y
        c-text: pad/left/with copy text amount/x fill
        d: to 1 amount/x - (length? text) / 2
        move/part c-text tail c-text  d
    ]
    
    sep: function[
        {Places a thousand separator dlm in number's integer part
        and left aligns the result padded to amount characters with fill}
        num    [number!]
        amount [integer!]
        dlm    [char!]
        fill   [char!]
    ][
        d: charset "0123456789"
        num: form num
        rev-num: reverse num
        rev-num: any [find/tail rev-num "." rev-num]
        parse rev-num [any[3 d ahead d insert dlm]]
        pad/left/with reverse num amount fill
        num
    ]
    
    fixed: function[
        num    [number!]
        amount [pair!]
        fill   [char!]
    ][
        frac: 1.0 / (10 ** amount/y)
        num: round/to num frac
        set[i f]split form num "."
        pad/left/with rejoin[i "." pad/with f amount/y #"0"] amount/x fill
    ]
    

    fmt: function[
        spec [string!]
        vals [block!]
    ][
        padding: space
        key: ""
        parse spec[copy key to[end | ["|" copy cmd to end (cmd: load cmd)]]]
        key: select vals to set-word! load key
        
        key: switch cmd/1 [
            left   [left   key cmd/2 any[cmd/3 padding]]
            right  [right  key cmd/2 any[cmd/3 padding]]
            center [center key cmd/2 any[cmd/3 padding]]
            sep    [sep    key cmd/2 any[cmd/3 #"'"] any[cmd/4 padding]]
            fixed  [fixed  key cmd/2 any[cmd/3 padding]]
        ]
        key
    ]
    

    set 'format function[
        {Simple string formatting using a block of keyword parameters}
        str [string!] "String to format" 
        vals [block!]  "A block with set-word - value pairs"
    ][
        parse str[
            any[
                to remove "{" 
                change copy subs to remove "}" (fmt subs vals)
            ]
        ]
        str    
    ]
]

;tests
print format {My name is {name|left 10x0 #"_"}. I'm {age | fixed 7x2} years old.}[age: 36,345 name: "John"]
print format {The price is USD {price|sep 15 #"," #"-"}.}[price: 1234502342.67]