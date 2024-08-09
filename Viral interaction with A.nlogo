; modelo de coinfeccion

;Globals--------------------------

breed [vectores vector]
breed [hospederos hospedero]
globals [ProbContagio listaExclusion listaExclusion7 listaExclusion14]
turtles-own [state sick Life-Span es-vector tick-nacimiento tick-infeccion enfermedades]

;setup----------------------------

to set-up
  clear-all
  reset-ticks
  set-default-shape vectores "bug"
  set listaExclusion [ ["B" "C" "D" "E"] ["A" "C" "D" "E"] ["C" "A" "B" "D" "E"] ["D" "C" "B" "E"] ["E" "B" "C" "D"] ]
  set listaExclusion7 [["A" "B" "C" "E"] ["B" "C" "D" "E" "A"] ["C" "D" "E" "A" "B"] ["D" "B" "C" "E"] ["E" "A" "B" "C" "D"]]
  set listaExclusion14 [["A" "B" "C" "D"] ["B" "C" "D" "E" "A"] ["C" "D" "E" "A" "B"] ["E" "B" "C" "D"] ["D" "A" "B" "C" "E"]]


  create-vectores 25
  [setxy random-xcor random-ycor
    set size 0.5
    set Life-Span 15 + random 50
    set color blue
    set es-vector True
    set enfermedades (list "Nada")
    set tick-nacimiento 0
    set tick-infeccion 0
  ]

  create-vectores 25
  [setxy random-xcor random-ycor
    set size 0.5
    set Life-Span 15 + random 50
    set color red
    set es-vector True
    set enfermedades (list "A")
    set tick-nacimiento 0
    set tick-infeccion 0
  ]

   create-vectores 25
  [setxy random-xcor random-ycor
    set size 0.5
    set Life-Span 15 + random 50
    set color red
    set es-vector True
    set enfermedades (list "B")
    set tick-nacimiento 0
    set tick-infeccion 0
  ]
  create-vectores 25
  [setxy random-xcor random-ycor
    set size 0.5
    set Life-Span 15 + random 50
    set color green
    set es-vector True
    set enfermedades (list "C")
    set tick-nacimiento 0
    set tick-infeccion 0
  ]
create-vectores 25
  [setxy random-xcor random-ycor
    set size 0.5
    set Life-Span 15 + random 50
    set color green
    set es-vector True
    set enfermedades (list "D")
    set tick-nacimiento 0
    set tick-infeccion 0
  ]
create-vectores 25
  [setxy random-xcor random-ycor
    set size 0.5
    set Life-Span 15 + random 50
    set color green
    set es-vector True
    set enfermedades (list "E")
    set tick-nacimiento 0
    set tick-infeccion 0
  ]

  create-hospederos 150
  [setxy random-xcor random-ycor
    set size 1
    set color violet
    set es-vector False
    set enfermedades (list "Nada")
  ]

end

;Actions--------------------

to go
  ask vectores
  [forward 1
    rt 50
    set Life-Span Life-Span - 1
    vector-infecta-hospedero
    vector-infecta-hospedero-inmune
    vector-infecta-hospedero-ant14   ; it works at the same that "vector-infecta-hospedero" but change the exclution virus list
    set es-vector True
    reproduce-vector
    Vector-Muere
  ]

   ask vectores with [member? "A" (enfermedades) = True or member? "B" (enfermedades) = True or member? "C" (enfermedades) = True or member? "D" (enfermedades) = True or member? "E" (enfermedades) = True]
  [ set tick-infeccion  tick-infeccion + 1
  ]

  ask hospederos
  [forward 1
    lt 45
    Hospedero-Infecta-Vector
    Hospedero-Infecta-Vector-inmune
    Hospedero-Infecta-Vector-ant14
        ]
    ;Hospedero-Recuperado
  ask hospederos with [member? "A" (enfermedades) = True or member? "B" (enfermedades) = True or member? "C" (enfermedades) = True or member? "D" (enfermedades) = True or member? "E" (enfermedades) = True]
  [ set tick-infeccion  tick-infeccion + 1
  ]
  tick
  if count vectores = 0 [stop]

end



;Metodos-------------------------------------------------------------------------------------------------------------------------------------------------

to vector-infecta-hospedero
if any? turtles-here with [ not es-vector]
  [ask one-of turtles-here with [ not es-vector]
    [ let temp [enfermedades] of one-of turtles-here with [es-vector]
      contagia temp
      ;set sick 7
      set color red
      show enfermedades
  ]]
end

to Vector-Muere
  if Life-Span <= 0
  [ die
          ]
end

to reproduce-vector
    if ticks > 0 [if (random-float 100 < 1)
    [ hatch 5 [ fd 1 ]
    set Life-Span 15 + random 50
  ]]
end

to Hospedero-Infecta-Vector
  if    any? turtles-here with [ es-vector]
  [ ask one-of turtles-here with [ es-vector ]
      [let temp [enfermedades] of one-of turtles-here with [not es-vector]
      contagia temp
      ;set sick 7
      set color red
      ;set tick-infeccion ticks
      show enfermedades
  ]]
end

to Hospedero-Recuperado
  ask turtles with [ not es-vector] [if sick = 0
    [ set color green
  ]]
end


to-report mePuedeDar [virus]

  let i 0
  let j 0
  let meDa True
  if member? virus enfermedades
      [set meDa False]
  while [i < length enfermedades and meDa]
  [
    set j 0
    let enfermedad  item i  enfermedades
    while [j < length listaExclusion and meDa]
    [
      let excluye item j listaExclusion
      if first excluye = enfermedad and member? virus sublist excluye 1 length excluye
      [
        set meDa False
      ]
      set j j + 1
    ]
     set i i + 1
  ]
  report meDa
end

to contagia [virusLista]
   let i 0
  while [i < length virusLista]
  [
   let virus item i virusLista
      if mePuedeDar virus
       [
       set enfermedades insert-item 0 enfermedades virus
       ]
    set i i + 1
  ]
end

;INSTRUCCIONES PARA INMUNE ------------------------------------------------------------------------------------

to-report mePuedeDar7 [virus]

  let i 0
  let j 0
  let meDa True
  if member? virus enfermedades
      [set meDa False]
  while [i < length enfermedades and meDa]
  [
    set j 0
    let enfermedad  item i  enfermedades
    while [j < length listaExclusion7 and meDa]
    [
      let excluye item j listaExclusion7
      if first excluye = enfermedad and member? virus sublist excluye 1 length excluye
      [
        set meDa False
      ]
      set j j + 1
    ]
     set i i + 1
  ]
  report meDa
end

to contagia7 [virusLista]
   let i 0
  while [i < length virusLista]
  [
   let virus item i virusLista
      if mePuedeDar7 virus
       [
       set enfermedades insert-item 0 enfermedades virus
       ]
    set i i + 1
  ]
end

to vector-infecta-hospedero-inmune
if any? turtles-here with [ not es-vector and tick-infeccion <  8]
  [ask one-of turtles-here with [ not es-vector and tick-infeccion < 8]
    [ let temp [enfermedades] of one-of turtles-here with [es-vector]
      contagia7 temp
      set tick-infeccion 1
      set color red
      show enfermedades
  ]]
end

to Hospedero-Infecta-Vector-inmune
  if    any? turtles-here with [ es-vector and tick-infeccion < 8]
  [ ask one-of turtles-here with [ es-vector and tick-infeccion < 8 ]
      [let temp [enfermedades] of one-of turtles-here with [not es-vector]
      contagia7 temp
      set color red
      set tick-infeccion 1
      show enfermedades
  ]]
end


;INSTRUCCIONES ANT14 -----------------------------------------------------------------------------------------------------------------------------------

to-report mePuedeDar14 [virus]

  let i 0
  let j 0
  let meDa True
  if member? virus enfermedades
      [set meDa False]
  while [i < length enfermedades and meDa]
  [
    set j 0
    let enfermedad  item i  enfermedades
    while [j < length listaExclusion14 and meDa]
    [
      let excluye item j listaExclusion14
      if first excluye = enfermedad and member? virus sublist excluye 1 length excluye
      [
        set meDa False
      ]
      set j j + 1
    ]
     set i i + 1
  ]
  report meDa
end

to contagia14 [virusLista]
   let i 0
  while [i < length virusLista]
  [
   let virus item i virusLista
      if mePuedeDar14 virus
       [
       set enfermedades insert-item 0 enfermedades virus
       ]
    set i i + 1
  ]
end
to vector-infecta-hospedero-ant14
if any? turtles-here with [ not es-vector ]
  [ask one-of turtles-here with [ not es-vector ]
    [ let temp [enfermedades] of one-of turtles-here with [es-vector]
      contagia14 temp
      set tick-infeccion 1
      set color red
      show enfermedades
  ]]
end

to Hospedero-Infecta-Vector-ant14
  if    any? turtles-here with [ es-vector and tick-infeccion < 8 or tick-infeccion > 14]
  [ ask one-of turtles-here with [ es-vector and tick-infeccion < 8 or tick-infeccion > 14 ]
      [let temp [enfermedades] of one-of turtles-here with [not es-vector]
      contagia14 temp
      set color red
      set tick-infeccion 1
      show enfermedades
  ]]
end
@#$#@#$#@
GRAPHICS-WINDOW
131
10
568
448
-1
-1
13.0
1
10
1
1
1
0
1
1
1
-16
16
-16
16
0
0
1
ticks
30.0

BUTTON
25
10
118
43
set-up
set-up
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
27
54
104
87
go
go
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
28
95
105
128
go
go
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

MONITOR
577
10
704
55
Health vectors
count vectores with [enfermedades = (list \"Nada\")]
0
1
11

MONITOR
718
11
829
56
Health hosts
count hospederos with [enfermedades = (list \"Nada\")]
0
1
11

PLOT
1000
37
1200
187
vectores
NIL
NIL
0.0
10.0
0.0
1.0
true
false
"" ""
PENS
"Vector A" 1.0 0 -14439633 true "" "plot (((count vectores with [member? \"A\" (enfermedades) = True])-\n(count vectores with [member? \"A\" (enfermedades) = True and member? \"B\" (enfermedades) = True ]))\n/ count vectores)"
"Vector B" 1.0 0 -13791810 true "" "plot (((count vectores with [member? \"B\" (enfermedades) = True])-\ncount vectores with [member? \"A\" (enfermedades) = True and member? \"B\" (enfermedades) = True ])\n / count vectores)"
"Vector AB" 1.0 0 -2674135 true "" "plot (count vectores with [member? \"A\" (enfermedades) = True and member? \"B\" (enfermedades) = True ]/ \ncount vectores)"

PLOT
1001
213
1201
363
Hospederos
días
prevalencia
0.0
10.0
0.0
1.0
true
false
"" ""
PENS
"H A" 1.0 0 -14439633 true "" "plot (((count hospederos with [member? \"A\" (enfermedades) = True])-\n(count hospederos with [member? \"A\" (enfermedades) = True and member? \"B\" (enfermedades) = True ]))\n/ count hospederos)"
"H B" 1.0 0 -14070903 true "" "plot (((count hospederos with [member? \"B\" (enfermedades) = True])-\n(count hospederos with [member? \"A\" (enfermedades) = True and member? \"B\" (enfermedades) = True ]))\n/ count hospederos)"
"H AB" 1.0 0 -5298144 true "" "plot(count hospederos with [member? \"A\" (enfermedades) = True and member? \"B\" (enfermedades) = True ]/ \ncount hospederos)"

MONITOR
581
299
713
344
Vector prevalence AB
count vectores with [member? \"A\" (enfermedades) = True and member? \"B\" (enfermedades) = True ]/ \ncount vectores
2
1
11

MONITOR
722
298
843
343
Host prevalence AB
count hospederos with [member? \"A\" (enfermedades) = True and member? \"B\" (enfermedades) = True ]/ \ncount hospederos
2
1
11

MONITOR
577
57
704
102
Vector prevalence A
((count vectores with [member? \"A\" (enfermedades) = True])-\n(count vectores with [member? \"A\" (enfermedades) = True and member? \"B\" (enfermedades) = True])-\n(count vectores with [member? \"A\" (enfermedades) = True and member? \"C\" (enfermedades) = True])-\n(count vectores with [member? \"A\" (enfermedades) = True and member? \"D\" (enfermedades) = True])-\n(count vectores with [member? \"A\" (enfermedades) = True and member? \"E\" (enfermedades) = True]))\n/ count vectores
2
1
11

MONITOR
579
104
705
149
Vector prevalence B
((count vectores with [member? \"B\" (enfermedades) = True])-\n(count vectores with [member? \"B\" (enfermedades) = True and member? \"A\" (enfermedades) = True])-\n(count vectores with [member? \"B\" (enfermedades) = True and member? \"C\" (enfermedades) = True])-\n(count vectores with [member? \"B\" (enfermedades) = True and member? \"D\" (enfermedades) = True])-\n(count vectores with [member? \"B\" (enfermedades) = True and member? \"E\" (enfermedades) = True]))\n / count vectores
2
1
11

MONITOR
718
58
830
103
Host prevalence A
((count hospederos with [member? \"A\" (enfermedades) = True])-\n(count hospederos with [member? \"A\" (enfermedades) = True and member? \"B\" (enfermedades) = True])-\n(count hospederos with [member? \"A\" (enfermedades) = True and member? \"C\" (enfermedades) = True])-\n(count hospederos with [member? \"A\" (enfermedades) = True and member? \"D\" (enfermedades) = True])-\n(count hospederos with [member? \"A\" (enfermedades) = True and member? \"E\" (enfermedades) = True]))\n/ count hospederos
2
1
11

MONITOR
718
104
831
149
Host prevalence B
((count hospederos with [member? \"B\" (enfermedades) = True])-\n(count hospederos with [member? \"B\" (enfermedades) = True and member? \"A\" (enfermedades) = True])-\n(count hospederos with [member? \"B\" (enfermedades) = True and member? \"C\" (enfermedades) = True])-\n(count hospederos with [member? \"B\" (enfermedades) = True and member? \"D\" (enfermedades) = True])-\n(count hospederos with [member? \"B\" (enfermedades) = True and member? \"E\" (enfermedades) = True]))\n/ count hospederos
2
1
11

MONITOR
580
155
705
200
Vector prevalence C
((count vectores with [member? \"C\" (enfermedades) = True])-\n(count vectores with [member? \"C\" (enfermedades) = True and member? \"B\" (enfermedades) = True])-\n(count vectores with [member? \"C\" (enfermedades) = True and member? \"A\" (enfermedades) = True])-\n(count vectores with [member? \"C\" (enfermedades) = True and member? \"D\" (enfermedades) = True])-\n(count vectores with [member? \"C\" (enfermedades) = True and member? \"E\" (enfermedades) = True]))\n/ count vectores
2
1
11

MONITOR
580
201
705
246
Vector prevalence D
((count vectores with [member? \"D\" (enfermedades) = True])-\n(count vectores with [member? \"D\" (enfermedades) = True and member? \"B\" (enfermedades) = True])-\n(count vectores with [member? \"D\" (enfermedades) = True and member? \"C\" (enfermedades) = True])-\n(count vectores with [member? \"D\" (enfermedades) = True and member? \"A\" (enfermedades) = True])-\n(count vectores with [member? \"D\" (enfermedades) = True and member? \"E\" (enfermedades) = True]))\n/ count vectores
2
1
11

MONITOR
581
248
705
293
Vector prevalence E
((count vectores with [member? \"E\" (enfermedades) = True])-\n(count vectores with [member? \"E\" (enfermedades) = True and member? \"B\" (enfermedades) = True])-\n(count vectores with [member? \"E\" (enfermedades) = True and member? \"C\" (enfermedades) = True])-\n(count vectores with [member? \"E\" (enfermedades) = True and member? \"D\" (enfermedades) = True])-\n(count vectores with [member? \"E\" (enfermedades) = True and member? \"A\" (enfermedades) = True]))\n/ count vectores
2
1
11

MONITOR
582
351
715
396
Vector prevalence AC
count vectores with [member? \"A\" (enfermedades) = True and member? \"C\" (enfermedades) = True ]/ \ncount vectores
2
1
11

MONITOR
584
401
717
446
Vector prevalence AD
count vectores with [member? \"A\" (enfermedades) = True and member? \"D\" (enfermedades) = True ]/ \ncount vectores
2
1
11

MONITOR
585
449
717
494
Vector prevalence AE
count vectores with [member? \"A\" (enfermedades) = True and member? \"E\" (enfermedades) = True ]/ \ncount vectores
2
1
11

MONITOR
719
152
833
197
Host prevalence C
((count hospederos with [member? \"C\" (enfermedades) = True])-\n(count hospederos with [member? \"C\" (enfermedades) = True and member? \"B\" (enfermedades) = True])-\n(count hospederos with [member? \"C\" (enfermedades) = True and member? \"A\" (enfermedades) = True])-\n(count hospederos with [member? \"C\" (enfermedades) = True and member? \"D\" (enfermedades) = True])-\n(count hospederos with [member? \"C\" (enfermedades) = True and member? \"E\" (enfermedades) = True]))\n/ count hospederos
2
1
11

MONITOR
718
201
832
246
Host prevalence D
((count hospederos with [member? \"D\" (enfermedades) = True])-\n(count hospederos with [member? \"D\" (enfermedades) = True and member? \"B\" (enfermedades) = True])-\n(count hospederos with [member? \"D\" (enfermedades) = True and member? \"C\" (enfermedades) = True])-\n(count hospederos with [member? \"D\" (enfermedades) = True and member? \"A\" (enfermedades) = True])-\n(count hospederos with [member? \"D\" (enfermedades) = True and member? \"E\" (enfermedades) = True]))\n/ count hospederos
2
1
11

MONITOR
718
248
831
293
Host prevalence E
((count hospederos with [member? \"E\" (enfermedades) = True])-\n(count hospederos with [member? \"E\" (enfermedades) = True and member? \"B\" (enfermedades) = True])-\n(count hospederos with [member? \"E\" (enfermedades) = True and member? \"C\" (enfermedades) = True])-\n(count hospederos with [member? \"E\" (enfermedades) = True and member? \"D\" (enfermedades) = True])-\n(count hospederos with [member? \"E\" (enfermedades) = True and member? \"A\" (enfermedades) = True]))\n/ count hospederos
2
1
11

MONITOR
724
351
847
396
Host prevalence AC
count hospederos with [member? \"A\" (enfermedades) = True and member? \"C\" (enfermedades) = True ]/ \ncount hospederos
2
1
11

MONITOR
724
401
847
446
Host prevalence AD
count hospederos with [member? \"A\" (enfermedades) = True and member? \"D\" (enfermedades) = True ]/ \ncount hospederos
2
1
11

MONITOR
726
449
847
494
Host prevalence AE
count hospederos with [member? \"A\" (enfermedades) = True and member? \"E\" (enfermedades) = True ]/ \ncount hospederos
2
1
11

@#$#@#$#@
## WHAT IS IT?

(a general understanding of what the model is trying to show or explain)

## HOW IT WORKS

(what rules the agents use to create the overall behavior of the model)

## HOW TO USE IT

(how to use the model, including a description of each of the items in the Interface tab)

## THINGS TO NOTICE

(suggested things for the user to notice while running the model)

## THINGS TO TRY

(suggested things for the user to try to do (move sliders, switches, etc.) with the model)

## EXTENDING THE MODEL

(suggested things to add or change in the Code tab to make the model more complicated, detailed, accurate, etc.)

## NETLOGO FEATURES

(interesting or unusual features of NetLogo that the model uses, particularly in the Code tab; or where workarounds were needed for missing features)

## RELATED MODELS

(models in the NetLogo Models Library and elsewhere which are of related interest)

## CREDITS AND REFERENCES

(a reference to the model's URL on the web if it has one, as well as any other necessary credits, citations, and links)
@#$#@#$#@
default
true
0
Polygon -7500403 true true 150 5 40 250 150 205 260 250

airplane
true
0
Polygon -7500403 true true 150 0 135 15 120 60 120 105 15 165 15 195 120 180 135 240 105 270 120 285 150 270 180 285 210 270 165 240 180 180 285 195 285 165 180 105 180 60 165 15

arrow
true
0
Polygon -7500403 true true 150 0 0 150 105 150 105 293 195 293 195 150 300 150

box
false
0
Polygon -7500403 true true 150 285 285 225 285 75 150 135
Polygon -7500403 true true 150 135 15 75 150 15 285 75
Polygon -7500403 true true 15 75 15 225 150 285 150 135
Line -16777216 false 150 285 150 135
Line -16777216 false 150 135 15 75
Line -16777216 false 150 135 285 75

bug
true
0
Circle -7500403 true true 96 182 108
Circle -7500403 true true 110 127 80
Circle -7500403 true true 110 75 80
Line -7500403 true 150 100 80 30
Line -7500403 true 150 100 220 30

butterfly
true
0
Polygon -7500403 true true 150 165 209 199 225 225 225 255 195 270 165 255 150 240
Polygon -7500403 true true 150 165 89 198 75 225 75 255 105 270 135 255 150 240
Polygon -7500403 true true 139 148 100 105 55 90 25 90 10 105 10 135 25 180 40 195 85 194 139 163
Polygon -7500403 true true 162 150 200 105 245 90 275 90 290 105 290 135 275 180 260 195 215 195 162 165
Polygon -16777216 true false 150 255 135 225 120 150 135 120 150 105 165 120 180 150 165 225
Circle -16777216 true false 135 90 30
Line -16777216 false 150 105 195 60
Line -16777216 false 150 105 105 60

car
false
0
Polygon -7500403 true true 300 180 279 164 261 144 240 135 226 132 213 106 203 84 185 63 159 50 135 50 75 60 0 150 0 165 0 225 300 225 300 180
Circle -16777216 true false 180 180 90
Circle -16777216 true false 30 180 90
Polygon -16777216 true false 162 80 132 78 134 135 209 135 194 105 189 96 180 89
Circle -7500403 true true 47 195 58
Circle -7500403 true true 195 195 58

circle
false
0
Circle -7500403 true true 0 0 300

circle 2
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240

cow
false
0
Polygon -7500403 true true 200 193 197 249 179 249 177 196 166 187 140 189 93 191 78 179 72 211 49 209 48 181 37 149 25 120 25 89 45 72 103 84 179 75 198 76 252 64 272 81 293 103 285 121 255 121 242 118 224 167
Polygon -7500403 true true 73 210 86 251 62 249 48 208
Polygon -7500403 true true 25 114 16 195 9 204 23 213 25 200 39 123

cylinder
false
0
Circle -7500403 true true 0 0 300

dot
false
0
Circle -7500403 true true 90 90 120

face happy
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 255 90 239 62 213 47 191 67 179 90 203 109 218 150 225 192 218 210 203 227 181 251 194 236 217 212 240

face neutral
false
0
Circle -7500403 true true 8 7 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Rectangle -16777216 true false 60 195 240 225

face sad
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 168 90 184 62 210 47 232 67 244 90 220 109 205 150 198 192 205 210 220 227 242 251 229 236 206 212 183

fish
false
0
Polygon -1 true false 44 131 21 87 15 86 0 120 15 150 0 180 13 214 20 212 45 166
Polygon -1 true false 135 195 119 235 95 218 76 210 46 204 60 165
Polygon -1 true false 75 45 83 77 71 103 86 114 166 78 135 60
Polygon -7500403 true true 30 136 151 77 226 81 280 119 292 146 292 160 287 170 270 195 195 210 151 212 30 166
Circle -16777216 true false 215 106 30

flag
false
0
Rectangle -7500403 true true 60 15 75 300
Polygon -7500403 true true 90 150 270 90 90 30
Line -7500403 true 75 135 90 135
Line -7500403 true 75 45 90 45

flower
false
0
Polygon -10899396 true false 135 120 165 165 180 210 180 240 150 300 165 300 195 240 195 195 165 135
Circle -7500403 true true 85 132 38
Circle -7500403 true true 130 147 38
Circle -7500403 true true 192 85 38
Circle -7500403 true true 85 40 38
Circle -7500403 true true 177 40 38
Circle -7500403 true true 177 132 38
Circle -7500403 true true 70 85 38
Circle -7500403 true true 130 25 38
Circle -7500403 true true 96 51 108
Circle -16777216 true false 113 68 74
Polygon -10899396 true false 189 233 219 188 249 173 279 188 234 218
Polygon -10899396 true false 180 255 150 210 105 210 75 240 135 240

house
false
0
Rectangle -7500403 true true 45 120 255 285
Rectangle -16777216 true false 120 210 180 285
Polygon -7500403 true true 15 120 150 15 285 120
Line -16777216 false 30 120 270 120

leaf
false
0
Polygon -7500403 true true 150 210 135 195 120 210 60 210 30 195 60 180 60 165 15 135 30 120 15 105 40 104 45 90 60 90 90 105 105 120 120 120 105 60 120 60 135 30 150 15 165 30 180 60 195 60 180 120 195 120 210 105 240 90 255 90 263 104 285 105 270 120 285 135 240 165 240 180 270 195 240 210 180 210 165 195
Polygon -7500403 true true 135 195 135 240 120 255 105 255 105 285 135 285 165 240 165 195

line
true
0
Line -7500403 true 150 0 150 300

line half
true
0
Line -7500403 true 150 0 150 150

pentagon
false
0
Polygon -7500403 true true 150 15 15 120 60 285 240 285 285 120

person
false
0
Circle -7500403 true true 110 5 80
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Rectangle -7500403 true true 127 79 172 94
Polygon -7500403 true true 195 90 240 150 225 180 165 105
Polygon -7500403 true true 105 90 60 150 75 180 135 105

plant
false
0
Rectangle -7500403 true true 135 90 165 300
Polygon -7500403 true true 135 255 90 210 45 195 75 255 135 285
Polygon -7500403 true true 165 255 210 210 255 195 225 255 165 285
Polygon -7500403 true true 135 180 90 135 45 120 75 180 135 210
Polygon -7500403 true true 165 180 165 210 225 180 255 120 210 135
Polygon -7500403 true true 135 105 90 60 45 45 75 105 135 135
Polygon -7500403 true true 165 105 165 135 225 105 255 45 210 60
Polygon -7500403 true true 135 90 120 45 150 15 180 45 165 90

sheep
false
15
Circle -1 true true 203 65 88
Circle -1 true true 70 65 162
Circle -1 true true 150 105 120
Polygon -7500403 true false 218 120 240 165 255 165 278 120
Circle -7500403 true false 214 72 67
Rectangle -1 true true 164 223 179 298
Polygon -1 true true 45 285 30 285 30 240 15 195 45 210
Circle -1 true true 3 83 150
Rectangle -1 true true 65 221 80 296
Polygon -1 true true 195 285 210 285 210 240 240 210 195 210
Polygon -7500403 true false 276 85 285 105 302 99 294 83
Polygon -7500403 true false 219 85 210 105 193 99 201 83

square
false
0
Rectangle -7500403 true true 30 30 270 270

square 2
false
0
Rectangle -7500403 true true 30 30 270 270
Rectangle -16777216 true false 60 60 240 240

star
false
0
Polygon -7500403 true true 151 1 185 108 298 108 207 175 242 282 151 216 59 282 94 175 3 108 116 108

target
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240
Circle -7500403 true true 60 60 180
Circle -16777216 true false 90 90 120
Circle -7500403 true true 120 120 60

tree
false
0
Circle -7500403 true true 118 3 94
Rectangle -6459832 true false 120 195 180 300
Circle -7500403 true true 65 21 108
Circle -7500403 true true 116 41 127
Circle -7500403 true true 45 90 120
Circle -7500403 true true 104 74 152

triangle
false
0
Polygon -7500403 true true 150 30 15 255 285 255

triangle 2
false
0
Polygon -7500403 true true 150 30 15 255 285 255
Polygon -16777216 true false 151 99 225 223 75 224

truck
false
0
Rectangle -7500403 true true 4 45 195 187
Polygon -7500403 true true 296 193 296 150 259 134 244 104 208 104 207 194
Rectangle -1 true false 195 60 195 105
Polygon -16777216 true false 238 112 252 141 219 141 218 112
Circle -16777216 true false 234 174 42
Rectangle -7500403 true true 181 185 214 194
Circle -16777216 true false 144 174 42
Circle -16777216 true false 24 174 42
Circle -7500403 false true 24 174 42
Circle -7500403 false true 144 174 42
Circle -7500403 false true 234 174 42

turtle
true
0
Polygon -10899396 true false 215 204 240 233 246 254 228 266 215 252 193 210
Polygon -10899396 true false 195 90 225 75 245 75 260 89 269 108 261 124 240 105 225 105 210 105
Polygon -10899396 true false 105 90 75 75 55 75 40 89 31 108 39 124 60 105 75 105 90 105
Polygon -10899396 true false 132 85 134 64 107 51 108 17 150 2 192 18 192 52 169 65 172 87
Polygon -10899396 true false 85 204 60 233 54 254 72 266 85 252 107 210
Polygon -7500403 true true 119 75 179 75 209 101 224 135 220 225 175 261 128 261 81 224 74 135 88 99

wheel
false
0
Circle -7500403 true true 3 3 294
Circle -16777216 true false 30 30 240
Line -7500403 true 150 285 150 15
Line -7500403 true 15 150 285 150
Circle -7500403 true true 120 120 60
Line -7500403 true 216 40 79 269
Line -7500403 true 40 84 269 221
Line -7500403 true 40 216 269 79
Line -7500403 true 84 40 221 269

wolf
false
0
Polygon -16777216 true false 253 133 245 131 245 133
Polygon -7500403 true true 2 194 13 197 30 191 38 193 38 205 20 226 20 257 27 265 38 266 40 260 31 253 31 230 60 206 68 198 75 209 66 228 65 243 82 261 84 268 100 267 103 261 77 239 79 231 100 207 98 196 119 201 143 202 160 195 166 210 172 213 173 238 167 251 160 248 154 265 169 264 178 247 186 240 198 260 200 271 217 271 219 262 207 258 195 230 192 198 210 184 227 164 242 144 259 145 284 151 277 141 293 140 299 134 297 127 273 119 270 105
Polygon -7500403 true true -1 195 14 180 36 166 40 153 53 140 82 131 134 133 159 126 188 115 227 108 236 102 238 98 268 86 269 92 281 87 269 103 269 113

x
false
0
Polygon -7500403 true true 270 75 225 30 30 225 75 270
Polygon -7500403 true true 30 75 75 30 270 225 225 270
@#$#@#$#@
NetLogo 6.1.1
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
<experiments>
  <experiment name="coinfeccion" repetitions="1000" sequentialRunOrder="false" runMetricsEveryStep="true">
    <setup>coinfeccion</setup>
    <go>go-coinf</go>
    <timeLimit steps="100"/>
    <metric>((count vectores with [member? "A" (enfermedades) = True])- (count vectores with [member? "A" (enfermedades) = True and member? "B" (enfermedades) = True ])) / count vectores</metric>
    <metric>((count vectores with [member? "B" (enfermedades) = True])- count vectores with [member? "A" (enfermedades) = True and member? "B" (enfermedades) = True ])  / count vectores</metric>
    <metric>count vectores with [member? "A" (enfermedades) = True and member? "B" (enfermedades) = True ]/ count vectores</metric>
    <metric>((count hospederos with [member? "A" (enfermedades) = True])- (count hospederos with [member? "A" (enfermedades) = True and member? "B" (enfermedades) = True ])) / count hospederos</metric>
    <metric>((count hospederos with [member? "B" (enfermedades) = True])- (count hospederos with [member? "A" (enfermedades) = True and member? "B" (enfermedades) = True ])) / count hospederos</metric>
    <metric>count hospederos with [member? "A" (enfermedades) = True and member? "B" (enfermedades) = True ]/ count hospederos</metric>
  </experiment>
  <experiment name="exclusion" repetitions="1000" sequentialRunOrder="false" runMetricsEveryStep="true">
    <setup>exclusion</setup>
    <go>go-excl</go>
    <timeLimit steps="100"/>
    <metric>((count vectores with [member? "A" (enfermedades) = True])- (count vectores with [member? "A" (enfermedades) = True and member? "B" (enfermedades) = True ])) / count vectores</metric>
    <metric>((count vectores with [member? "B" (enfermedades) = True])- count vectores with [member? "A" (enfermedades) = True and member? "B" (enfermedades) = True ])  / count vectores</metric>
    <metric>count vectores with [member? "A" (enfermedades) = True and member? "B" (enfermedades) = True ]/ count vectores</metric>
    <metric>((count hospederos with [member? "A" (enfermedades) = True])- (count hospederos with [member? "A" (enfermedades) = True and member? "B" (enfermedades) = True ])) / count hospederos</metric>
    <metric>((count hospederos with [member? "B" (enfermedades) = True])- (count hospederos with [member? "A" (enfermedades) = True and member? "B" (enfermedades) = True ])) / count hospederos</metric>
    <metric>count hospederos with [member? "A" (enfermedades) = True and member? "B" (enfermedades) = True ]/ count hospederos</metric>
  </experiment>
  <experiment name="ant7" repetitions="1000" sequentialRunOrder="false" runMetricsEveryStep="true">
    <setup>ant7</setup>
    <go>go-ant7</go>
    <timeLimit steps="100"/>
    <metric>((count vectores with [member? "A" (enfermedades) = True])- (count vectores with [member? "A" (enfermedades) = True and member? "B" (enfermedades) = True ])) / count vectores</metric>
    <metric>((count vectores with [member? "B" (enfermedades) = True])- count vectores with [member? "A" (enfermedades) = True and member? "B" (enfermedades) = True ])  / count vectores</metric>
    <metric>count vectores with [member? "A" (enfermedades) = True and member? "B" (enfermedades) = True ]/ count vectores</metric>
    <metric>((count hospederos with [member? "A" (enfermedades) = True])- (count hospederos with [member? "A" (enfermedades) = True and member? "B" (enfermedades) = True ])) / count hospederos</metric>
    <metric>((count hospederos with [member? "B" (enfermedades) = True])- (count hospederos with [member? "A" (enfermedades) = True and member? "B" (enfermedades) = True ])) / count hospederos</metric>
    <metric>count hospederos with [member? "A" (enfermedades) = True and member? "B" (enfermedades) = True ]/ count hospederos</metric>
  </experiment>
  <experiment name="ant7-14" repetitions="1000" sequentialRunOrder="false" runMetricsEveryStep="true">
    <setup>ant7-14</setup>
    <go>go-ant7-14</go>
    <timeLimit steps="100"/>
    <metric>((count vectores with [member? "A" (enfermedades) = True])- (count vectores with [member? "A" (enfermedades) = True and member? "B" (enfermedades) = True ])) / count vectores</metric>
    <metric>((count vectores with [member? "B" (enfermedades) = True])- count vectores with [member? "A" (enfermedades) = True and member? "B" (enfermedades) = True ])  / count vectores</metric>
    <metric>count vectores with [member? "A" (enfermedades) = True and member? "B" (enfermedades) = True ]/ count vectores</metric>
    <metric>((count hospederos with [member? "A" (enfermedades) = True])- (count hospederos with [member? "A" (enfermedades) = True and member? "B" (enfermedades) = True ])) / count hospederos</metric>
    <metric>((count hospederos with [member? "B" (enfermedades) = True])- (count hospederos with [member? "A" (enfermedades) = True and member? "B" (enfermedades) = True ])) / count hospederos</metric>
    <metric>count hospederos with [member? "A" (enfermedades) = True and member? "B" (enfermedades) = True ]/ count hospederos</metric>
  </experiment>
  <experiment name="conjunto" repetitions="100" runMetricsEveryStep="true">
    <setup>set-up</setup>
    <go>go</go>
    <timeLimit steps="100"/>
    <metric>((count vectores with [member? "A" (enfermedades) = True])-(count vectores with [member? "A" (enfermedades) = True and member? "B" (enfermedades) = True])-(count vectores with [member? "A" (enfermedades) = True and member? "C" (enfermedades) = True])-(count vectores with [member? "A" (enfermedades) = True and member? "D" (enfermedades) = True])-(count vectores with [member? "A" (enfermedades) = True and member? "E" (enfermedades) = True])) / count vectores</metric>
    <metric>((count vectores with [member? "B" (enfermedades) = True])-(count vectores with [member? "B" (enfermedades) = True and member? "A" (enfermedades) = True])-(count vectores with [member? "B" (enfermedades) = True and member? "C" (enfermedades) = True])-(count vectores with [member? "B" (enfermedades) = True and member? "D" (enfermedades) = True])-(count vectores with [member? "B" (enfermedades) = True and member? "E" (enfermedades) = True])) / count vectores</metric>
    <metric>((count vectores with [member? "C" (enfermedades) = True])-(count vectores with [member? "C" (enfermedades) = True and member? "B" (enfermedades) = True])-(count vectores with [member? "C" (enfermedades) = True and member? "A" (enfermedades) = True])-(count vectores with [member? "C" (enfermedades) = True and member? "D" (enfermedades) = True])-(count vectores with [member? "C" (enfermedades) = True and member? "E" (enfermedades) = True])) / count vectores</metric>
    <metric>((count vectores with [member? "D" (enfermedades) = True])-(count vectores with [member? "D" (enfermedades) = True and member? "B" (enfermedades) = True])-(count vectores with [member? "D" (enfermedades) = True and member? "C" (enfermedades) = True])-(count vectores with [member? "D" (enfermedades) = True and member? "A" (enfermedades) = True])-(count vectores with [member? "D" (enfermedades) = True and member? "E" (enfermedades) = True])) / count vectores</metric>
    <metric>((count vectores with [member? "E" (enfermedades) = True])-(count vectores with [member? "E" (enfermedades) = True and member? "B" (enfermedades) = True])-(count vectores with [member? "E" (enfermedades) = True and member? "C" (enfermedades) = True])-(count vectores with [member? "E" (enfermedades) = True and member? "D" (enfermedades) = True])-(count vectores with [member? "E" (enfermedades) = True and member? "A" (enfermedades) = True])) / count vectores</metric>
    <metric>count vectores with [member? "A" (enfermedades) = True and member? "B" (enfermedades) = True ] / count vectores</metric>
    <metric>count vectores with [member? "A" (enfermedades) = True and member? "C" (enfermedades) = True ] / count vectores</metric>
    <metric>count vectores with [member? "A" (enfermedades) = True and member? "D" (enfermedades) = True ] / count vectores</metric>
    <metric>count vectores with [member? "A" (enfermedades) = True and member? "E" (enfermedades) = True ] / count vectores</metric>
    <metric>((count hospederos with [member? "A" (enfermedades) = True])-(count hospederos with [member? "A" (enfermedades) = True and member? "B" (enfermedades) = True])-(count hospederos with [member? "A" (enfermedades) = True and member? "C" (enfermedades) = True])-(count hospederos with [member? "A" (enfermedades) = True and member? "D" (enfermedades) = True])-(count hospederos with [member? "A" (enfermedades) = True and member? "E" (enfermedades) = True])) / count hospederos</metric>
    <metric>((count hospederos with [member? "B" (enfermedades) = True])-(count hospederos with [member? "B" (enfermedades) = True and member? "A" (enfermedades) = True])-(count hospederos with [member? "B" (enfermedades) = True and member? "C" (enfermedades) = True])-(count hospederos with [member? "B" (enfermedades) = True and member? "D" (enfermedades) = True])-(count hospederos with [member? "B" (enfermedades) = True and member? "E" (enfermedades) = True])) / count hospederos</metric>
    <metric>((count hospederos with [member? "C" (enfermedades) = True])-(count hospederos with [member? "C" (enfermedades) = True and member? "B" (enfermedades) = True])-(count hospederos with [member? "C" (enfermedades) = True and member? "A" (enfermedades) = True])-(count hospederos with [member? "C" (enfermedades) = True and member? "D" (enfermedades) = True])-(count hospederos with [member? "C" (enfermedades) = True and member? "E" (enfermedades) = True])) / count hospederos</metric>
    <metric>((count hospederos with [member? "D" (enfermedades) = True])-(count hospederos with [member? "D" (enfermedades) = True and member? "B" (enfermedades) = True])-(count hospederos with [member? "D" (enfermedades) = True and member? "C" (enfermedades) = True])-(count hospederos with [member? "D" (enfermedades) = True and member? "A" (enfermedades) = True])-(count hospederos with [member? "D" (enfermedades) = True and member? "E" (enfermedades) = True])) / count hospederos</metric>
    <metric>((count hospederos with [member? "E" (enfermedades) = True])-(count hospederos with [member? "E" (enfermedades) = True and member? "B" (enfermedades) = True])-(count hospederos with [member? "E" (enfermedades) = True and member? "C" (enfermedades) = True])-(count hospederos with [member? "E" (enfermedades) = True and member? "D" (enfermedades) = True])-(count hospederos with [member? "E" (enfermedades) = True and member? "A" (enfermedades) = True])) / count hospederos</metric>
    <metric>count hospederos with [member? "A" (enfermedades) = True and member? "B" (enfermedades) = True ] / count hospederos</metric>
    <metric>count hospederos with [member? "A" (enfermedades) = True and member? "C" (enfermedades) = True ] / count hospederos</metric>
    <metric>count hospederos with [member? "A" (enfermedades) = True and member? "D" (enfermedades) = True ] / count hospederos</metric>
    <metric>count hospederos with [member? "A" (enfermedades) = True and member? "E" (enfermedades) = True ] / count hospederos</metric>
  </experiment>
</experiments>
@#$#@#$#@
@#$#@#$#@
default
0.0
-0.2 0 0.0 1.0
0.0 1 1.0 0.0
0.2 0 0.0 1.0
link direction
true
0
Line -7500403 true 150 150 90 180
Line -7500403 true 150 150 210 180
@#$#@#$#@
0
@#$#@#$#@
