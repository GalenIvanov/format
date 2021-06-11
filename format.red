Red [
    Title:  "String formatting, similar to Python's format()" 
    Author: "Galen Ivanov"
]

fmt: context [
 
    left: function[
        {Left aligns the text, truncated to field/y chars (0 means no change).
        Pads to field/x chars to the right using fill} 
        text   
        field [pair!]
        fill   [char!]
    ][
        text: form text
        if zero? field/y[field/y: length? text]
        pad/with take/part text field/y field/x fill
    ]
    
    right: function[
        {Right aligns the text, truncated to field/y chars (means is no change).
        Pads to field/x chars to the left using fill} 
        text  
        field [pair!]
        fill   [char!]
    ][
        text: form text
        if zero? field/y[field/y: length? text]
        pad/left/with take/part text field/y field/x fill
    ]
    
    center: function[
        {Centers the text, truncated to field/y chars (0 means no change).
        Pads to field/x chars to the left and right using fill} 
        text   
        field [pair!]
        fill   [char!]
    ][
        text: form text
        if zero? field/y[field/y: length? text]
        text: take/part text field/y
        c-text: pad/left/with copy text field/x fill
        d: to 1 field/x - (length? text) / 2
        move/part c-text tail c-text  d
    ]
    
    sep: function[
        {Places a thousand separator dlm in number's integer part
        and left aligns the result padded to field characters with fill}
        num    [number!]
        field [integer!]
        dlm    [char!]
        fill   [char!]
    ][
        d: charset "0123456789"
        num: form num
        rev-num: reverse num
        rev-num: any [find/tail rev-num "." rev-num]
        parse rev-num [any[3 d ahead d insert dlm]]
        pad/left/with reverse num field fill
        num
    ]
    
    fixed: function[
        {Represents a fixed point number}
        num    [number!]
        field [pair!]
        fill   [char!]
    ][
        frac: 1.0 / (10 ** field/y)
        num: round/to num frac
        set[i f]split form num "."
        pad/left/with rejoin[i "." pad/with f field/y #"0"] field/x fill
    ]
    
    sci: function[
        {Represents a number in a modified normalized form, mantissa 1-10}
        num    [number!]
        field [pair!]
        fill   [char!]
    ][
        order: round/floor log-10 num
        coef: fixed num / (10 ** order) as-pair 0 field/y space
        order: to 1 order
        order: rejoin[pick["-" "" "+"]2 + sign? order pad/left/with absolute order 2 #"0"]
        rejoin[right coef as-pair field/x - 1 - length? order 0 fill "e" order]
    ]
    
    base: function[
        {Converts a decimal integer to base n}
        n      [number!]  "number to convert"
        b      [integer!] "Base - from 2 to 36"
        field [pair!]    "field width x leading zeroes fill"
        fill   [char!]    "character to pad with"
        sgn    [logic!]   "Include a base signature after converted number, like 10011(2)"
    ][
        if any[b < 2 b > 36][
            print "Unsupported base"
            return "Error!"
        ]
        c: "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ"
        n: to 1 n
        digits: rejoin reverse collect[
            until[
                keep c/(n % b + 1)
                0 = n: to 1 n / b
            ]
        ]
        digits: pad/left/with digits field/y #"0"
        if sgn[repend digits["(" b ")"]]
        right digits as-pair field/x 0 fill
    ]
    
    dd-mm-yyyy: function[
        {Displays date in dd-mm-yyyy format: 11-06-2021}
        d   [date!]
        sep [char!]
    ][
        rejoin[d/4 sep d/3 sep d/2]
    ]
    
    yyyy-mm-dd: function[
        {Displays date in yyyy-mm-dd format: 2021-06-2011}
        d   [date!]
        sep [char!]
    ][
        rejoin[d/2 sep d/3 sep d/4]
    ]
    
    yyyy-ww-ddd: function[
        {Displays date in yyyy-ww-ddd format (year, week, day)): 2021-W24-5}
        d   [date!]
        sep [char!]
    ][
        rejoin[d/2 sep "Week" d/13 sep d/10]
        
    ]
    
    yyyy-ddd: function[
        {Displays date in yyyy-ddd format (year, day): 2021-d162}
        d   [date!]
        sep [char!]
    ][
        rejoin[d/2 sep "Day" d/11]
    ]


    fmt: function[
        spec [string!]
        vals [block!]
    ][
        padding: space
        key: ""
        parse spec[copy key to[end | ["|" copy cmd to end (cmd: load cmd)]]]
        key: select vals to set-word! load key
        
        if not block? cmd[cmd: to [] cmd]
        
        key: switch cmd/1 [
            left   [left   key cmd/2 any[cmd/3 padding]]
            right  [right  key cmd/2 any[cmd/3 padding]]
            center [center key cmd/2 any[cmd/3 padding]]
            sep    [sep    key cmd/2 any[cmd/3 #"'"] any[cmd/4 padding]]
            fixed  [fixed  key cmd/2 any[cmd/3 padding]]
            sci    [sci    key cmd/2 any[cmd/3 padding]]
            base   [base   key cmd/2 cmd/3 any[cmd/4 padding] to-logic any[cmd/5 off]]
            dd-mm-yyyy  [dd-mm-yyyy key any[cmd/2 #"-"]]
            yyyy-mm-dd  [yyyy-mm-dd key any[cmd/2 #"-"]]
            yyyy-ww-ddd [yyyy-ww-ddd key any[cmd/2 #"-"]]
            yyyy-ddd    [yyyy-ddd key any[cmd/2 #"-"]]
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
