globals [
  current-number-of-cars
  ;;number_pedestrians_using
  current-number-of-pedestrians
  maximum-number-of-cars
  maximum-number-of-pedestrians
  maximum-parking-speed 
  minimum-parking-speed 
  ;;maximum-number-cars-enter-parking
  numbers-car-entering-parking
  day-of-week
  deceleration
  acceleration
  police-officers?
  list-times-to-enter-parking
  maximum-time-to-enter-parking
  number-of-cars-in-the-parking
  car-time-to-crossing
  pedestrian-time-to-crossing2
  pedestrian-time-to-crossing
  time-to-crossing 
  ;;current-number-of-cars
  ]
breed [cars car]
breed [pedestrians pedestrian]
breed[houses house]
breed[crossings crossing]
breed[lights light
   
  ]
breed [police-officers police-officer]
cars-own [ speed maximum-speed minimum-speed wait-time stop? time-to-enter-parking time-entry-car 
  politeness
  ]
pedestrians-own[ walk-speed 
  walk-time
  crossing-part
  waiting?
  
  ]
police-officers-own[
  number-of-pedestrians-to-change
  number-of-cars-to-change
  car-priority?
  policy
  mylight
  is-coordinate?
  ]
lights-own[
  last-time-changed
  ]
patches-own
[
  
  meaning  
  number_pedestrians_using
  green-light-up? 

  traffic
]





to setup 
  clear-all
   reset-ticks
  set list-times-to-enter-parking []
  
  set number-of-cars-in-the-parking 0
  set maximum-parking-speed 1 
  set maximum-time-to-enter-parking 0
  set minimum-parking-speed 0.2
  set current-number-of-cars 0
  set numbers-car-entering-parking 0 
  set deceleration 0.2
  set acceleration 0.1
  set day-of-week random(7)
  set police-officers?  true
  set car-time-to-crossing 5
   set pedestrian-time-to-crossing2 15
  set pedestrian-time-to-crossing 30
  ;;set time-to-crossing 15
  ;;clear-all
  ;;reset-ticks
  
  set-numbers-according-to-hour-and-day-of-week


  generate-parking
  ;;ask patches [ generate-parking ]
  generate-cars
  ;;if (police-officers? = true )
    ;;[generate-police-officers]
  generate-police-officers
 
  generate-police-officers-policies
  generate-pedestrians
   reset-ticks
  tick
  
end 
to generate-parking

 ask patches with [   (pycor < 1 and pycor > -8 and pxcor < 24  and pxcor > -25) or 
   (pycor < 1 and pycor >= -16 and pxcor > 10 and pxcor < 30) 
   or (pycor < 1 and pycor > -3 and  pxcor <= -25) 
  or (pycor > -8  and pycor < -4 and  pxcor <= -25) or (pycor >= 4 and pycor < 14 and pxcor <= 30  and pxcor >= -30)
  or (pycor <= 3  and pycor >= 1 and pxcor >= 10 and pxcor <= 30) or (pycor = -3  and  pxcor >= -30 and pxcor <= -27) 
   ] [
  set pcolor grey
  set meaning "road"
 
    ]
   ask patches with [   (pycor = -6  and pxcor = -30  ) or 
   (pycor = -1 and  pxcor =  -30) ] [
  
  set meaning "car-entry"

    ]
    ask patches with [   (pycor <= -8 and pxcor >= 10 and pxcor <= 30 ) ] [
  
  set meaning "car-exit"
  
    ]
   
 
  ask patches with [(pycor = -3  and  pxcor > -25 and pxcor < -13) or (pycor = -3  and  pxcor > -11 and pxcor < -1) 
    or (pycor = -3  and  pxcor > 0 and pxcor <= 10) or
    (pycor = 9  and  pxcor >= -30 and pxcor < 30) ] 
  [
    set pcolor white
    sprout 1 [
      set shape "road2"
      set color grey 
      set heading 0
      stamp
      die
    ]
    set meaning "road-lane"
    ]
      ask patches with [ (pxcor = 15  and  pycor >= -16 and pycor <= -8) or (pxcor = 20  and  pycor >= -16 and pycor <= -8) 
        or (pxcor = 25  and  pycor >= -16 and pycor <= -8) 
     ] [
    set pcolor white
    sprout 1 [
      set shape "road2"
      set color grey 
      set heading 90
      stamp
      die
    ]
    set meaning "road-lane"
  ]
  ask patches with [ (pycor <= -8  and pycor >= -11 and pxcor >= -30 and pxcor <= 10) or (pycor >= 1  and pycor <= 3 and pxcor >= -30 and pxcor <= 25) 
    or (pycor >= 14  and pycor <= 16 and pxcor >= -30 and pxcor <= 30) or (pycor >= -16  and pycor <= 3 and pxcor = 30 )
    ;;or (pycor = -3   and pxcor <= -25  )
    or (pycor = -4   and pxcor <= -25  )
    
    ] [
  set pcolor brown + 2
  sprout 1 [
    set shape "tile stones"
    set color 36
    stamp
    die
  ]
  set meaning "sidewalk"]
  ask patches with [ (pycor = -3  and  pxcor = -27) or  (pycor = -4  and  pxcor = -27) 
    ] [
  
  set meaning "police-officers-place"]
   ask patches with [  (pycor = -3  and  pxcor = -13) or (pycor = -3  and  pxcor = -1) 
    or  (pycor = -4  and  pxcor = -13) or (pycor = -4  and  pxcor = -1) 
    ] [
  set pcolor grey
  set meaning "police-officers-place"]
    
  
    
  
  ask patches with [pcolor = black] [
    if count neighbors with [pcolor = black] = 8 and not any? turtles in-radius 4 [
      sprout-houses 1 [
        set shape one-of ["house" "house bungalow" "house ranch" "house colonial" "house efficiency" "house two story"]
        set size 4
        stamp
      ]
    ]
  ]
  ask houses [die]
    ask patches with [ (pxcor = -12  and pycor > -8 and pycor < 1 ) or (pxcor = -11  and pycor > -8 and pycor < 1 ) or 
      (pxcor = 1 and pycor > -8 and pycor < 1) or (pxcor = 0 and pycor > -8 and pycor < 1)
      or (pxcor = -26 and pycor > -8 and pycor < -4 ) 
      or (pxcor = -26 and pycor >= -3 and pycor < 1 )
      or (pxcor = -25 and pycor > -8 and pycor < -4 ) 
      or (pxcor = -25 and pycor >= -3 and pycor < 1 )
      ][
    sprout-crossings 1 [
      set shape "crossing"
      set color white
      set heading 90
      set size 1
      ;;stamp die
    ]
  ]

 ask crossings with [;;(pycor = -3  and  pxcor = -12) or (pycor = -3  and  pxcor = -11) or 
    (pycor = -4  and  pxcor = -12) or (pycor = -4  and  pxcor = -11)
   ;;or (pycor = -3  and  pxcor = 0)  or (pycor = -3  and  pxcor = 1) 
   or (pycor = -4  and  pxcor = 0) or (pycor = -4  and  pxcor = 1) 
    ] [
    set shape "waitpoint"
    set meaning "waitpoint2"
    set color black + 1
    ;;show list pxcor pycor
    stamp die
  ]
  ask crossings [
    ;;set will-cross? false
    set meaning "crossing"
    stamp
    die
  ]
      ask patches with [meaning = "crossing"] [
    ask neighbors4 [
      if meaning = "sidewalk" [
        ;;show list pxcor pycor
        set meaning "waitpoint"
        ]
      ]
    ]
      
     
    ask patches with [(pycor = -4 and pxcor = -26) or (pycor = -4 and pxcor = -25) ] [
       set meaning "waitpoint2"
      ]
    

 
end 
to generate-police-officers
     while [ count police-officers < number-of-police-officers][
      ask one-of patches with [meaning = "police-officers-place"] [
      if not any? police-officers-on patch pxcor (pycor + 1) and not any? police-officers-here and not any? police-officers-on patch pxcor (pycor - 1) [
      sprout-police-officers 1 [
        ifelse coordinate-policy = true 
        [set policy "coordinate policy" ]
        [set policy  "own policy"]
        
        set shape "person police" 
       
        set size 1
        set number-of-pedestrians-to-change 1 + random 4
        set number-of-cars-to-change 1 + random 4
        if pxcor = -27
            [set number-of-cars-to-change 1]
        set car-priority? one-of [true false]
         ;;set light min-one-of lights [distance]
        ;;set mylight min-one-of lights  in-radius 2 [abs([ycor] of myself - ycor)]
        ifelse policy = "coordinate policy"
            [set is-coordinate?  true] 
            [set is-coordinate?  false] 
        ]
      
       
      
      ]
      
        
      ]
      
     ]
     let leftmost-police-officer min-one-of police-officers [xcor]
     ask  leftmost-police-officer[set policy  "own policy"
       set is-coordinate?  false
       ]
     
  
  
end  
to generate-police-officers-policies
   ask patches with [ (meaning = "police-officers-place") and ( not any? police-officers-on patch pxcor pycor )] [
    sprout-lights 1 [
      set color one-of  [red green]
      set shape "lights"
      set last-time-changed ticks
    ]
    ask police-officers[
      set mylight min-one-of lights  in-radius 2 [abs([ycor] of myself - ycor)]
      ]
  ]
end 
to setup-road
   if (pycor < 8) and (pycor > -8) and (pxcor < 24)and(pxcor > -25)[ set pcolor grey ]
   if (pycor < 8) and (pycor > -16) and (pxcor >= 14) and (pxcor < 30)[ set pcolor grey ]
   if (pycor < 8) and (pycor > 0.5) and  (pxcor <= -25)[ set pcolor grey ]
   if (pycor > -8 ) and (pycor < -0.5) and  (pxcor <= -25)[ set pcolor grey ]
end 
to set-numbers-according-to-hour-and-day-of-week
  ifelse (day-of-week >= 1 and day-of-week <= 5  )  
      [set  maximum-number-of-cars  floor(4500 / 24 );;187
       set maximum-number-of-pedestrians 70]
      [set  maximum-number-of-cars  floor(1600 / 24 );;66
        set maximum-number-of-pedestrians 50
        ]
  
end
 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
to generate-cars
     ;;set-default-shape cars "car top"
    if (numbers-car-entering-parking < maximum-number-cars-enter-parking)[
    ask n-of (random(3)) patches with [meaning = "car-entry"] [
    ifelse not any? cars-on patch pxcor (pycor + 2) and not any? cars-here and not any? cars-on patch pxcor (pycor - 2)
    and not any? cars-on patch (pxcor + 1) pycor and not any? cars-on patch (pxcor + 2) (pycor) and not any? cars-on patch (pxcor + 3) (pycor) 
    and not any? cars-on patch (pxcor + 4) (pycor)
    and not any? patches with [meaning = "crossing"] in-radius 2 [
      sprout-cars 1 [
        set size 2
        set color one-of [blue red violet green   ]
        ;;set speed  minimum-parking-speed + random-poisson (maximum-parking-speed - minimum-parking-speed)
        set minimum-speed  0.1
        set maximum-speed  maximum-parking-speed
        set speed 0.1 + random-float .9
        ;;set will-turn? "maybe"
        set stop? "maybe"
        set shape "car top"

        set heading 90
        set time-entry-car ticks
        set time-to-enter-parking 0

      ]
    ]
    [
      ]
  ]
   set  numbers-car-entering-parking count(cars)
 ]

end 

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
to generate-pedestrians
    while [ count pedestrians < maximum-number-of-pedestrians] [
    ask one-of patches with [meaning = "sidewalk"] [
      sprout-pedestrians 1 [
        set walk-speed random 7 + 5
        set size 1
        set waiting? false

        set walk-time random pedestrian-time-to-crossing
        set shape one-of ["person business" "person construction" "person doctor" 
          "person farmer" "person graduate" "person lumberjack"  "person service" 
          "person student" 
        ]
        
      ]
    ]
  ]

  
end



to go
  move-cars
  generate-cars
  move-pedestrians
  police-regulate-traffic

  
  tick
end


to-report closest-car-in-my-direction
  let k 1
  
  while [patch-ahead k != nobody  and not any? cars-on patch-ahead k] [
    set k (k + 1)
    ]
  
  ifelse patch-ahead k = nobody 
   [report nobody
     ]
   [
     ifelse any? cars-on patch-ahead k
        [report one-of  cars-on patch-ahead k]
        [report nobody]
     ]
end
to-report closest-pedestrian-in-my-direction
  let k 1
  
  while [patch-ahead k != nobody  and not any? pedestrians-on patch-ahead k] [
    set k (k + 1)
    ]
  
  ifelse patch-ahead k = nobody 
   [report nobody
     ]
   [
     ifelse any? pedestrians-on patch-ahead k
        [report one-of  pedestrians-on patch-ahead k]
        [report nobody]
     ]
end  
  
to regulate-speed
 
 
  let rightmost-police-officer max-one-of police-officers  [ xcor  ]
  let car-ahead nobody
  let car-ahead2 nobody
  
  ;;let k  min-one-of  cars with [ heading = [heading ] of myself and  any? cars-on patch-ahead k ][]
  ;;let cars-ahead  cars with [ heading = [heading ] of myself and  ]
  let closest-car closest-car-in-my-direction
  ;;if closest-car != nobody and 
  ifelse (closest-car-in-my-direction != nobody )
  [ 
    let approching-speed speed - [speed] of closest-car-in-my-direction 
    ifelse (approching-speed > 0 and (distance closest-car-in-my-direction) > approching-speed  + acceleration + size )
    [ifelse  (speed + acceleration) < maximum-parking-speed [set speed speed + acceleration
      ;;show "acele1"
      ;;show speed
      ] 
     [ set speed  maximum-parking-speed
       ;;show "max"
       ]
    ]
    [
     ifelse  ( approching-speed > 0  and (distance closest-car-in-my-direction) < approching-speed + size  )
     [
       ifelse [speed] of closest-car-in-my-direction = 0
      
          [set speed 0
            ;;show "cero"
            ]
          [
            ifelse [speed] of closest-car-in-my-direction - deceleration > 0
             [set speed [speed] of closest-car-in-my-direction 
             ;;  show "decel1"
               ]
             [set speed 0
               ;;show "cero1"
               ]
            ]
;         ifelse speed - deceleration > 0
;         [set speed speed - deceleration
;           show "decele1"]
;         [set speed 0
;           show "cero1"]
     
      ;;show speed
       ]
     [
       if  (approching-speed > 0 and distance closest-car-in-my-direction <  size  )
     [
       
         set speed 0
         ;;show "cero2"
     
         ;;show speed
       ]
     ]
     ]
   if (approching-speed < 0  and distance closest-car-in-my-direction > speed +  acceleration - [speed] of closest-car-in-my-direction + size) ;;and ( [pxcor] of patch-ahead speed   > [xcor] of  closest-car - 4 )
           [
             ifelse  (speed + acceleration) < maximum-parking-speed [set speed speed + acceleration
               ;;show "acele2"
               ;;show speed
              ] 
           [ set speed  maximum-parking-speed
             ;;show "max2"
             ]
             ]
;    if  (speed + acceleration) < maximum-parking-speed 
;        [set speed speed + acceleration
;      show "acele"
;      show speed
;      ] 
   
  ]
  [
    
      ifelse  (speed + acceleration) < maximum-parking-speed 
        [set speed speed + acceleration
      ;;show "acele3"
      ;;show speed
      ] 
     [
      set speed maximum-parking-speed
      ;;show "max2"
      ]
    ]
  if closest-pedestrian-in-my-direction != nobody 
  [if distance closest-pedestrian-in-my-direction < speed + size / 2 
      [ set speed 0
        ;;show "cero2"
        ]
  ]
   ;;if patch-ahead 1 != nobody and [meaning] of patch-ahead 1 = "crossing"  and [number_pedestrians_using] of patch-ahead 1 > 0 and [number_pedestrians_using] of patch-ahead 2 > 0 [set speed 0
    ;; show "cero3"
    ;; ]
     
    

end


to move-cars
   ;;set list-times-to-enter-parking []
  ask cars [
    regulate-speed
    ;;show(speed)
    let rightmost-police-officer max-one-of police-officers  [ xcor  ]
    let closest-police-officer min-one-of police-officers  in-radius 4 [ distance  myself ]
    let closest-light nobody
     if closest-police-officer != nobody [set closest-light [mylight] of closest-police-officer]
    ifelse  (xcor <= ([xcor] of rightmost-police-officer));;((ycor <= -4 and ycor >= -8   and xcor < 11) or (ycor  >= -3 and ycor  <= 0  and xcor < 21) )
    [;;move-to patch-ahead 1
      ifelse[meaning] of patch-ahead (speed + size / 2) = "crossing" and speed > 0
         [
            
             ifelse    (closest-light != nobody and [color] of closest-light = green ) or (closest-light = nobody)
             [
               if [meaning] of patch-ahead 1 = "crossing" and [meaning] of patch-ahead 2 = "crossing" and [number_pedestrians_using] of patch-ahead 1 = 0 
               [ask patch-ahead 1[
                 set traffic traffic + 1 
                 ask other neighbors with [meaning = "crossing"] [set traffic traffic + 1]
               ]
               ]
                if patch-left-and-ahead 180 1 != nobody and [meaning] of patch-left-and-ahead 180 1 = "crossing" and [meaning] of patch-left-and-ahead 180 2 = "crossing"  and meaning != "crossing" 
                [
                   
                     ask patch-left-and-ahead 180 1 [
                  set traffic traffic - 1 
                 ask other neighbors with [meaning = "crossing"] [set traffic traffic - 1]
                ]
               ]
               fd speed
               
               
               ]
             [
               if  (closest-light != nobody and [color] of closest-light = red )
               [  
                 set speed 0
                
                 ]
               
              ]
           ]
         
         [
            ifelse  (closest-light != nobody and [color] of closest-light = green and speed = 0  )  ;;and ([meaning] of patch-ahead 1 = "crossing" or [meaning] of patch-ahead 2 = "crossing")
               [  
                 regulate-speed
;                 if speed + acceleration < maximum-parking-speed
;                  [set speed speed + acceleration ]
;                  [set speed maximum-parking-speed ]
                  if ([meaning] of patch-ahead 1 = "crossing" or [meaning] of patch-ahead 2 = "crossing")
               [  if [meaning] of patch-ahead 1 = "crossing" and [meaning] of patch-ahead 2 = "crossing" and [number_pedestrians_using] of patch-ahead 1 = 0 
               [ask patch-ahead 1[
                 set traffic traffic + 1 
                 ask other neighbors with [meaning = "crossing"] [set traffic traffic + 1]
               ]
               ]
                if patch-left-and-ahead 180 1 != nobody and [meaning] of patch-left-and-ahead 180 1 = "crossing" and [meaning] of patch-left-and-ahead 180 2 = "crossing"  and meaning != "crossing" 
                [
                   
                     ask patch-left-and-ahead 180 1 [
                  set traffic traffic - 1 
                 ask other neighbors with [meaning = "crossing"] [set traffic traffic - 1]
                ]
               ]
               ]
           fd speed
                 ]
               [
                 ;;if (closest-light = nobody and speed  > 0)
                ;; [
                   fd speed
                   
                 ;;  ]
                
                 ]
            
              
          ]
      ]
    [
       ;;move-to patch-ahead 0 rt 35
      ifelse (can-turn-right?) and heading  = 90
      [ 
          if (ycor <= -4 and ycor >= -8
              ) [
            ;;move-to  patch -6 12
             rt 90 
             set heading 180
          
           fd speed  
        
            ]
          if (ycor  >= -3 and ycor  <= 0 )
          [;;move-to  patch -1 22
            rt 90
            set heading 180
          
            fd speed 
         
            ]
        ;;  ]
      ]
       [
        

         ]
       
          ifelse heading = 180 and not can-move? speed
          ;;ifelse [meaning] of patch-here = "car-exit" or ycor < -8
          [
            ;;stop
           
            ;;hide-turtle
           
            set time-to-enter-parking (ticks - time-entry-car)
            ;;show list-times-to-enter-parking
            set list-times-to-enter-parking (lput time-to-enter-parking  list-times-to-enter-parking )
            set number-of-cars-in-the-parking (number-of-cars-in-the-parking + 1)
            ;;show(number-of-cars-in-the-parking)
            if time-to-enter-parking > maximum-time-to-enter-parking
              [ set maximum-time-to-enter-parking time-to-enter-parking  ]
            ;;show(maximum-time-to-enter-parking)
            die
            ]
          [
          fd speed 
          ;;move-to patch-ahead 1  
          
          ] 
       ]
    ]
       

end
to-report can-turn-right?
  if [pxcor] of patch-here >= 12 and [pxcor] of patch-here <= 13 and [pycor] of patch-here  <= -4 and [pycor] of patch-here >= -8  [


      if not any? cars-on patch-right-and-ahead 90 speed 
 
       [report true]

  ]

;  ]

;    ]
 if [pxcor] of patch-here >= 17 and [pxcor] of patch-here <= 18 and [pycor] of patch-here >= -3 and [pycor] of patch-here   <= 0  [
     if not any? cars-on patch-right-and-ahead 90 speed 
      [report true]
      ]
  if [pxcor] of patch-here >= 22 and [pxcor] of patch-here <= 23 and [pycor] of patch-here >= -3 and [pycor] of patch-here   <= 0  [
     if not any? cars-on patch-right-and-ahead 90 speed 
      [report true]
      ]
  ;;if pxcor mod 40 = 36 and pycor mod 22 = 18 and heading = 90 [report true]
  ;;if pxcor mod 40 = 0 and pycor mod 22 = 0 and heading = 270 [report true]
  report false
end





to move-pedestrians
  ask pedestrians [
        
    ifelse walk-time >= pedestrian-time-to-crossing [
     let closest-police-officer min-one-of police-officers  in-radius 5 [ distance myself ]
     ;;let closest-police-officer one-of police-officers  with [ xcor = [xcor] of myself ]
     let closest-light nobody
     if closest-police-officer != nobody [set closest-light [mylight] of closest-police-officer]
      if crossing-part >= 1 [
        ifelse   (closest-light != nobody and [color] of closest-light = red)
          [cross-the-street
            
          stop]
          [
           ;; if (closest-light != nobody and [color] of closest-light = green )
            ;;set walk-speed  0
            set waiting? true
            ]
          
      ]
      if meaning = "waitpoint" [
        set crossing-part 1
      ]
      face min-one-of patches with [meaning = "waitpoint"] [distance myself]
      walk
    ]
    [walk]
   
  ]
  
end
to move-pedestrians2
  ask pedestrians [
    let closest-police-officer min-one-of police-officers  in-radius 4 [ distance myself ]
     ;;let closest-police-officer one-of police-officers  with [ xcor = [xcor] of myself ]
     let closest-light nobody
     if closest-police-officer != nobody [set closest-light [mylight] of closest-police-officer]
     ;;show closest-light
     ifelse   (closest-light != nobody and [color] of closest-light = red ) ;;or (closest-light = nobody)
     [
      ;; show(walk-time)
    
       ;;show(time-to-crossing)
        ifelse walk-time >= pedestrian-time-to-crossing [
          if crossing-part >= 1
          [
          
           cross-the-street
            stop
          ]
          if meaning = "waitpoint" [
            set crossing-part 1
          ]
         face min-one-of patches with [meaning = "waitpoint"] [distance myself]
         walk
         ]
         [walk]
     ]
     [
       set walk-speed 0
       set waiting? true
       
      ]
   
  ]
  
end
to walk
  
  ifelse  (patch-ahead 1 != nobody and [meaning] of patch-ahead 1 = "sidewalk") and (patch-ahead 1 != nobody and [meaning] of patch-ahead 1 = "waitpoint" )[
    ifelse any? other pedestrians-on patch-ahead 1[
      rt random 45
      lt  random 45
      set walk-time walk-time + 1
    ]
    [fd (walk-speed / 100)
      set walk-time walk-time + 1]
  ]  
  [ 
    rt random 120
    lt random 120
    if patch-ahead 1 != nobody [
    if [meaning] of patch-ahead  1  = "sidewalk" or [meaning] of patch-ahead  1  = "waitpoint"
     [
      fd (walk-speed / 100)
    ]
    ]
    set walk-time walk-time + 1
  ] 
end

to cross-the-street
  if crossing-part = 1[
    ifelse any? patches with [meaning = "waitpoint2"] in-radius 5  
    [
    face min-one-of patches with [meaning = "waitpoint2"] in-radius 5 [abs([xcor] of myself - pxcor)]
    ]
    [
       
        
      ]
    ask patches in-cone 3 180 with [meaning = "crossing"] [set number_pedestrians_using number_pedestrians_using + 1]
    set crossing-part 2
  ]
  if crossing-part = 2 [
    if heading > 315 and heading < 45 [set heading 0];;norte
    if heading > 45 and heading < 135 [set heading 90];;este
    if heading > 135 and heading < 225 [set heading 180];;sur
    if heading > 225 and heading < 315 [set heading 270];;oeste
  ]
  if meaning = "waitpoint2" and crossing-part = 2 [
    rt 180
    ask patches in-cone 3 180 with [meaning = "crossing"] [set number_pedestrians_using number_pedestrians_using - 1]
    lt 180
    ask patches in-cone 3 180 with [meaning = "crossing"] [set number_pedestrians_using number_pedestrians_using + 1]
    set crossing-part 3
  ] 
  if crossing-part = 3 and meaning = "waitpoint" [
    rt 180
    ask patches in-cone 3 180 with [meaning = "crossing"] [set number_pedestrians_using number_pedestrians_using - 1]
    lt 180
    set crossing-part 0
    set walk-time 0
  ]
  ifelse meaning = "waitpoint" and crossing-part = 2  and ([traffic] of patch-ahead 1 > 0 or [traffic] of patch-ahead 2 > 0) [
    fd 0
    set waiting? true
  ]
  [
;    ifelse meaning = "waitpoint2" and crossing-part = 3 
;    and ([traffic] of patch-ahead 1 > 0 or [traffic] of patch-ahead 2 > 0)
;    [
;      fd 0
;      set waiting? true
;    ]
    ;;[
      if patch-ahead 1 != nobody [
      if not any? cars-on patch-ahead 1 [
        fd walk-speed / 50 set waiting? false
      ]
      ]
   ;; ] 
  ]
  
  
  
  
end
to police-regulate-traffic
  ask police-officers[
    apply-policy
    ]
end 
to-report change-color-light-with-own-policy? 
  let light ([mylight] of self)
  let mycolor ([color] of light)
  let number-of-cars-waiting 0
  let number-of-cars-passing 0
  let number-of-pedestrians-waiting 0
  let number-of-pedestrians-passing 0
 let closest-police-officer-to-the-left min-one-of police-officers   with [[xcor] of myself > xcor] [  abs([ycor] of myself - ycor) ]
 ;;show closest-police-officer-to-the-left
 ifelse closest-police-officer-to-the-left != nobody 
 [set number-of-cars-waiting count  cars  with [  (xcor  <=  [xcor] of myself) and speed = 0 and xcor - size / 2 > [xcor] of closest-police-officer-to-the-left ]
 ]
 [set number-of-cars-waiting count  cars  with [  (xcor <=  [xcor] of myself) and speed = 0 ]]
 ;;show number-of-cars-waiting
 set number-of-cars-passing count  cars  with [  (xcor  >  [xcor] of myself  and xcor - size / 2 <= ([xcor] of myself + 3) )]
 ;;show number-of-cars-passing
 set number-of-pedestrians-passing count  pedestrians  with [  ( abs(xcor - [xcor] of myself) <= 3 and ([meaning] of patch-here = "crossing" or [meaning] of patch-here = "waitpoint2" )  ) ]
   ;;or ( abs(xcor - [xcor] of myself) <= 3 and ([meaning] of patch-here != "sidewalk") and ([meaning] of patch-here != "waitpoint") and 
    ;; ([meaning] of patch-here != "waitpoint2") and  ( any?  neighbors with [ meaning = "crossing"])  and walk-speed > 0 ) ]
 ;;show number-of-pedestrians-passing
 set number-of-pedestrians-waiting count  pedestrians  with [   (abs(xcor - [xcor] of myself) <= 3 )  and ([meaning] of patch-here = "waitpoint";; or [meaning] of patch-here = "waitpoint2" 
      )]
 ;;show number-of-pedestrians-waiting
  if number-of-cars-passing > 0 and mycolor = green
     [report false]
  if number-of-cars-passing > 0 and mycolor = red 
     [report true]
  if number-of-pedestrians-passing > 0 and mycolor = red
     [report false] 
  if number-of-pedestrians-passing > 0 and mycolor = green
     [report true] 
 if number-of-cars-waiting > number-of-cars-to-change and number-of-pedestrians-passing = 0 and mycolor = red
  [report true]
 if number-of-pedestrians-waiting > number-of-pedestrians-to-change and number-of-cars-passing = 0 and mycolor = green
     [report true]
  if  number-of-cars-waiting > 0 and  number-of-pedestrians-passing = 0 and mycolor = red and car-priority?
     [report true]
   if  number-of-pedestrians-waiting > 0 and  number-of-cars-passing = 0 and mycolor = green and not car-priority?
     [report true]
   if  number-of-cars-waiting > 0 and  number-of-pedestrians-passing = 0 and mycolor = red and ticks - ([last-time-changed] of light) > 10
     [report true]
   if  number-of-pedestrians-waiting > 0 and  number-of-cars-passing = 0 and mycolor = green and ticks - ([last-time-changed] of light) > 10
     [report true]
   
  report false 
end 

to-report change-color-of-light-with-coordinate-policy? [change-color]
    let light ([mylight] of self)
  let mycolor ([color] of light)
  let number-of-cars-waiting 0
  let number-of-cars-passing 0
  let number-of-pedestrians-waiting 0
  let number-of-pedestrians-passing 0
 let closest-police-officer-to-the-left min-one-of police-officers   with [[xcor] of myself > xcor] [  abs([ycor] of myself - ycor) ]
 ifelse closest-police-officer-to-the-left != nobody 
 [set number-of-cars-waiting count  cars  with [  (xcor  <=  [xcor] of myself) and speed = 0 and xcor - size / 2 > [xcor] of closest-police-officer-to-the-left ]
 ;;show number-of-cars-waiting
 ]
 [set number-of-cars-waiting count  cars  with [  (xcor  <=  [xcor] of myself) and speed = 0 ]]
 ;;show number-of-cars-waiting
 set number-of-cars-passing count  cars  with [  (xcor  >  [xcor] of myself  and xcor - size / 2 <= ([xcor] of myself + 3) )]
 ;;show number-of-cars-passing
 set number-of-pedestrians-passing count  pedestrians  with [  ( abs(xcor - [xcor] of myself) <= 3 and ([meaning] of patch xcor ycor = "crossing" or [meaning] of patch-here = "waitpoint2" )  ) ]
  ;; or ( abs(xcor - [xcor] of myself) <= 3 and ([meaning] of patch xcor ycor != "sidewalk") and ([meaning] of patch xcor ycor != "waitpoint") and 
   ;;  ([meaning] of patch xcor ycor != "waitpoint2") and  ( any?  neighbors with [ meaning = "crossing"])  and walk-speed > 0 ) ]
 ;;show number-of-pedestrians-passing
 set number-of-pedestrians-waiting count  pedestrians  with [   (abs(xcor - [xcor] of myself) <= 3 )  and ([meaning] of patch-here = "waitpoint";; or [meaning] of patch-here = "waitpoint2" 
      )]

 

  if number-of-cars-passing = 0 and change-color = red and mycolor = green 
     [report true]
  if number-of-pedestrians-passing = 0 and change-color = green and mycolor = red
     [report true]  
  report false  
end 
to apply-policy
  ifelse coordinate-policy 
    [ 
      ask police-officers with [policy = "own policy"]
      [
        set policy  "coordinate policy"
        set is-coordinate? true
        ]
      let leftmost-police-officer min-one-of police-officers [xcor]
     ask  leftmost-police-officer[set policy  "own policy"
       set is-coordinate?  false
       ]
    ] 
    [
       ask police-officers with [policy = "coordinate policy"]
      [
        set policy  "own policy"
        set is-coordinate? false
        ]
      
      ]
  let current-time ticks
  
  let light ([mylight] of self)
  let mycolor ([color] of light)
  ifelse policy = "coordinate policy" and is-coordinate?
  [
     let closest-police-officer-to-the-left min-one-of police-officers   with [[xcor] of myself > xcor] [  abs([ycor] of myself - ycor) ]
     let light-closest-police-officer-to-the-left nobody
     
     if closest-police-officer-to-the-left != nobody [set light-closest-police-officer-to-the-left ([mylight] of closest-police-officer-to-the-left )]
     ifelse (light-closest-police-officer-to-the-left != nobody )
        [ 
          let left-color ([color] of light-closest-police-officer-to-the-left )
          ;;primera variante poner la misma luz que el policia de la izquierda si se puede 
          ifelse not time-coordinate?
             [ let change-color? change-color-of-light-with-coordinate-policy?  left-color
              if change-color? 
              [
                ask light [set color left-color
                 set last-time-changed ticks]
                ]
             ]
           ;;segunda variante poner si ha pasado el tiempo de cruce de los autos y es rojo poner a verde
          [ 
           if  (current-time - ([last-time-changed] of light-closest-police-officer-to-the-left)) > car-time-to-crossing and left-color = red and change-color-of-light-with-coordinate-policy?  left-color
             [  ask light [set color green 
                  set last-time-changed ticks]
             ]
             
             if  (current-time - ([last-time-changed] of light-closest-police-officer-to-the-left)) >  pedestrian-time-to-crossing2  and left-color = green and change-color-of-light-with-coordinate-policy?  left-color
             [  ask light [set color green 
                  set last-time-changed ticks]
             ]
          ]
        ]
        [
          ;;generar aleatorio
          let change? change-color-of-light-with-coordinate-policy?  green
          ifelse change?  and  mycolor = red 
          [
               ask light [set color red
                  set last-time-changed ticks]
            
           ]
           [
            set  change? change-color-of-light-with-coordinate-policy?  red
            if change?  and  mycolor = green 
             [ 
               ask light [set color red
                 set last-time-changed ticks]
              ]
            
            ]
         ]  
      ];;;
  
  [
    ifelse policy = "own policy"
    [
      ;;let current-time ticks
     
      let change1? change-color-light-with-own-policy? 
      ;;show change1?
      ifelse ( change1?   and mycolor = green )
      [
        
        if current-time - ([last-time-changed] of light) > car-time-to-crossing
          [
            ask light [set color red
           set last-time-changed ticks
          
           ]
            
          ]
        ;;show light
       
        ]
      [
        if  change1? and mycolor = red  [
         if current-time - ([last-time-changed] of light) > pedestrian-time-to-crossing2
          [
            ask light [set color green
            set last-time-changed ticks 
          
            ]
            ]
          ;;show light
          
          ]
        ]
      
    
    ]
    [;;alguna otra politica
      
      ]
    
    ]
  
  
  
  
end 
@#$#@#$#@
GRAPHICS-WINDOW
315
10
1118
470
30
16
13.0
1
10
1
1
1
0
0
0
1
-30
30
-16
16
0
0
1
ticks
30.0

BUTTON
32
10
95
43
setup
setup
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
171
10
234
43
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
0

SLIDER
24
77
259
110
maximum-number-cars-enter-parking
maximum-number-cars-enter-parking
0
100
20
1
1
NIL
HORIZONTAL

SLIDER
23
125
259
158
number-of-police-officers
number-of-police-officers
0
3
3
1
1
NIL
HORIZONTAL

PLOT
31
211
231
361
Maximum time for entering paking
Number of ticks
Tiime to enter parking
0.0
500.0
0.0
200.0
true
false
"" ""
PENS
"default" 1.0 0 -16777216 true "" "plot   maximum-time-to-enter-parking"

PLOT
43
392
243
542
Mean entry time to parking
Number of ticks
Time o enter parking
0.0
500.0
0.0
200.0
true
false
"" ""
PENS
"default" 1.0 0 -16777216 true "" "if is-list? list-times-to-enter-parking and not empty? list-times-to-enter-parking[plot mean list-times-to-enter-parking]"

SWITCH
21
169
171
202
coordinate-policy
coordinate-policy
1
1
-1000

SWITCH
177
170
304
203
time-coordinate?
time-coordinate?
1
1
-1000

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

building store
false
0
Rectangle -7500403 true true 30 45 45 240
Rectangle -16777216 false false 30 45 45 165
Rectangle -7500403 true true 15 165 285 255
Rectangle -16777216 true false 120 195 180 255
Line -7500403 true 150 195 150 255
Rectangle -16777216 true false 30 180 105 240
Rectangle -16777216 true false 195 180 270 240
Line -16777216 false 0 165 300 165
Polygon -7500403 true true 0 165 45 135 60 90 240 90 255 135 300 165
Rectangle -7500403 true true 0 0 75 45
Rectangle -16777216 false false 0 0 75 45

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

car top
true
0
Polygon -7500403 true true 151 8 119 10 98 25 86 48 82 225 90 270 105 289 150 294 195 291 210 270 219 225 214 47 201 24 181 11
Polygon -16777216 true false 210 195 195 210 195 135 210 105
Polygon -16777216 true false 105 255 120 270 180 270 195 255 195 225 105 225
Polygon -16777216 true false 90 195 105 210 105 135 90 105
Polygon -1 true false 205 29 180 30 181 11
Line -7500403 true 210 165 195 165
Line -7500403 true 90 165 105 165
Polygon -16777216 true false 121 135 180 134 204 97 182 89 153 85 120 89 98 97
Line -16777216 false 210 90 195 30
Line -16777216 false 90 90 105 30
Polygon -1 true false 95 29 120 30 119 11

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

crossing
true
15
Line -16777216 false 150 90 150 210
Line -16777216 false 120 90 120 210
Line -16777216 false 90 90 90 210
Line -16777216 false 240 90 240 210
Line -16777216 false 270 90 270 210
Line -16777216 false 30 90 30 210
Line -16777216 false 60 90 60 210
Line -16777216 false 210 90 210 210
Line -16777216 false 180 90 180 210
Rectangle -1 true true 0 0 30 300
Rectangle -7500403 true false 120 0 150 300
Rectangle -1 true true 180 0 210 300
Rectangle -7500403 true false 240 0 270 300
Rectangle -1 true true 30 0 60 300
Rectangle -7500403 true false 90 0 120 300
Rectangle -1 true true 150 0 180 300
Rectangle -7500403 true false 270 0 300 300
Rectangle -1 true true 60 0 90 300
Rectangle -1 true true 210 0 240 300

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

house bungalow
false
0
Rectangle -7500403 true true 210 75 225 255
Rectangle -7500403 true true 90 135 210 255
Rectangle -16777216 true false 165 195 195 255
Line -16777216 false 210 135 210 255
Rectangle -16777216 true false 105 202 135 240
Polygon -7500403 true true 225 150 75 150 150 75
Line -16777216 false 75 150 225 150
Line -16777216 false 195 120 225 150
Polygon -16777216 false false 165 195 150 195 180 165 210 195
Rectangle -16777216 true false 135 105 165 135

house colonial
false
0
Rectangle -7500403 true true 270 75 285 255
Rectangle -7500403 true true 45 135 270 255
Rectangle -16777216 true false 124 195 187 256
Rectangle -16777216 true false 60 195 105 240
Rectangle -16777216 true false 60 150 105 180
Rectangle -16777216 true false 210 150 255 180
Line -16777216 false 270 135 270 255
Polygon -7500403 true true 30 135 285 135 240 90 75 90
Line -16777216 false 30 135 285 135
Line -16777216 false 255 105 285 135
Line -7500403 true 154 195 154 255
Rectangle -16777216 true false 210 195 255 240
Rectangle -16777216 true false 135 150 180 180

house efficiency
false
0
Rectangle -7500403 true true 180 90 195 195
Rectangle -7500403 true true 90 165 210 255
Rectangle -16777216 true false 165 195 195 255
Rectangle -16777216 true false 105 202 135 240
Polygon -7500403 true true 225 165 75 165 150 90
Line -16777216 false 75 165 225 165

house ranch
false
0
Rectangle -7500403 true true 270 120 285 255
Rectangle -7500403 true true 15 180 270 255
Polygon -7500403 true true 0 180 300 180 240 135 60 135 0 180
Rectangle -16777216 true false 120 195 180 255
Line -7500403 true 150 195 150 255
Rectangle -16777216 true false 45 195 105 240
Rectangle -16777216 true false 195 195 255 240
Line -7500403 true 75 195 75 240
Line -7500403 true 225 195 225 240
Line -16777216 false 270 180 270 255
Line -16777216 false 0 180 300 180

house two story
false
0
Polygon -7500403 true true 2 180 227 180 152 150 32 150
Rectangle -7500403 true true 270 75 285 255
Rectangle -7500403 true true 75 135 270 255
Rectangle -16777216 true false 124 195 187 256
Rectangle -16777216 true false 210 195 255 240
Rectangle -16777216 true false 90 150 135 180
Rectangle -16777216 true false 210 150 255 180
Line -16777216 false 270 135 270 255
Rectangle -7500403 true true 15 180 75 255
Polygon -7500403 true true 60 135 285 135 240 90 105 90
Line -16777216 false 75 135 75 180
Rectangle -16777216 true false 30 195 93 240
Line -16777216 false 60 135 285 135
Line -16777216 false 255 105 285 135
Line -16777216 false 0 180 75 180
Line -7500403 true 60 195 60 240
Line -7500403 true 154 195 154 255

leaf
false
0
Polygon -7500403 true true 150 210 135 195 120 210 60 210 30 195 60 180 60 165 15 135 30 120 15 105 40 104 45 90 60 90 90 105 105 120 120 120 105 60 120 60 135 30 150 15 165 30 180 60 195 60 180 120 195 120 210 105 240 90 255 90 263 104 285 105 270 120 285 135 240 165 240 180 270 195 240 210 180 210 165 195
Polygon -7500403 true true 135 195 135 240 120 255 105 255 105 285 135 285 165 240 165 195

lights
false
0
Rectangle -16777216 true false 15 15 285 285
Rectangle -7500403 true true 30 30 270 270

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

person business
false
0
Rectangle -1 true false 120 90 180 180
Polygon -13345367 true false 135 90 150 105 135 180 150 195 165 180 150 105 165 90
Polygon -7500403 true true 120 90 105 90 60 195 90 210 116 154 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 183 153 210 210 240 195 195 90 180 90 150 165
Circle -7500403 true true 110 5 80
Rectangle -7500403 true true 127 76 172 91
Line -16777216 false 172 90 161 94
Line -16777216 false 128 90 139 94
Polygon -13345367 true false 195 225 195 300 270 270 270 195
Rectangle -13791810 true false 180 225 195 300
Polygon -14835848 true false 180 226 195 226 270 196 255 196
Polygon -13345367 true false 209 202 209 216 244 202 243 188
Line -16777216 false 180 90 150 165
Line -16777216 false 120 90 150 165

person construction
false
0
Rectangle -7500403 true true 123 76 176 95
Polygon -1 true false 105 90 60 195 90 210 115 162 184 163 210 210 240 195 195 90
Polygon -13345367 true false 180 195 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285
Circle -7500403 true true 110 5 80
Line -16777216 false 148 143 150 196
Rectangle -16777216 true false 116 186 182 198
Circle -1 true false 152 143 9
Circle -1 true false 152 166 9
Rectangle -16777216 true false 179 164 183 186
Polygon -955883 true false 180 90 195 90 195 165 195 195 150 195 150 120 180 90
Polygon -955883 true false 120 90 105 90 105 165 105 195 150 195 150 120 120 90
Rectangle -16777216 true false 135 114 150 120
Rectangle -16777216 true false 135 144 150 150
Rectangle -16777216 true false 135 174 150 180
Polygon -955883 true false 105 42 111 16 128 2 149 0 178 6 190 18 192 28 220 29 216 34 201 39 167 35
Polygon -6459832 true false 54 253 54 238 219 73 227 78
Polygon -16777216 true false 15 285 15 255 30 225 45 225 75 255 75 270 45 285

person doctor
false
0
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Polygon -13345367 true false 135 90 150 105 135 135 150 150 165 135 150 105 165 90
Polygon -7500403 true true 105 90 60 195 90 210 135 105
Polygon -7500403 true true 195 90 240 195 210 210 165 105
Circle -7500403 true true 110 5 80
Rectangle -7500403 true true 127 79 172 94
Polygon -1 true false 105 90 60 195 90 210 114 156 120 195 90 270 210 270 180 195 186 155 210 210 240 195 195 90 165 90 150 150 135 90
Line -16777216 false 150 148 150 270
Line -16777216 false 196 90 151 149
Line -16777216 false 104 90 149 149
Circle -1 true false 180 0 30
Line -16777216 false 180 15 120 15
Line -16777216 false 150 195 165 195
Line -16777216 false 150 240 165 240
Line -16777216 false 150 150 165 150

person farmer
false
0
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Polygon -1 true false 60 195 90 210 114 154 120 195 180 195 187 157 210 210 240 195 195 90 165 90 150 105 150 150 135 90 105 90
Circle -7500403 true true 110 5 80
Rectangle -7500403 true true 127 79 172 94
Polygon -13345367 true false 120 90 120 180 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 180 90 172 89 165 135 135 135 127 90
Polygon -6459832 true false 116 4 113 21 71 33 71 40 109 48 117 34 144 27 180 26 188 36 224 23 222 14 178 16 167 0
Line -16777216 false 225 90 270 90
Line -16777216 false 225 15 225 90
Line -16777216 false 270 15 270 90
Line -16777216 false 247 15 247 90
Rectangle -6459832 true false 240 90 255 300

person graduate
false
0
Circle -16777216 false false 39 183 20
Polygon -1 true false 50 203 85 213 118 227 119 207 89 204 52 185
Circle -7500403 true true 110 5 80
Rectangle -7500403 true true 127 79 172 94
Polygon -8630108 true false 90 19 150 37 210 19 195 4 105 4
Polygon -8630108 true false 120 90 105 90 60 195 90 210 120 165 90 285 105 300 195 300 210 285 180 165 210 210 240 195 195 90
Polygon -1184463 true false 135 90 120 90 150 135 180 90 165 90 150 105
Line -2674135 false 195 90 150 135
Line -2674135 false 105 90 150 135
Polygon -1 true false 135 90 150 105 165 90
Circle -1 true false 104 205 20
Circle -1 true false 41 184 20
Circle -16777216 false false 106 206 18
Line -2674135 false 208 22 208 57

person lumberjack
false
0
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Polygon -2674135 true false 60 196 90 211 114 155 120 196 180 196 187 158 210 211 240 196 195 91 165 91 150 106 150 135 135 91 105 91
Circle -7500403 true true 110 5 80
Rectangle -7500403 true true 127 79 172 94
Polygon -6459832 true false 174 90 181 90 180 195 165 195
Polygon -13345367 true false 180 195 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285
Polygon -6459832 true false 126 90 119 90 120 195 135 195
Rectangle -6459832 true false 45 180 255 195
Polygon -16777216 true false 255 165 255 195 240 225 255 240 285 240 300 225 285 195 285 165
Line -16777216 false 135 165 165 165
Line -16777216 false 135 135 165 135
Line -16777216 false 90 135 120 135
Line -16777216 false 105 120 120 120
Line -16777216 false 180 120 195 120
Line -16777216 false 180 135 210 135
Line -16777216 false 90 150 105 165
Line -16777216 false 225 165 210 180
Line -16777216 false 75 165 90 180
Line -16777216 false 210 150 195 165
Line -16777216 false 180 105 210 180
Line -16777216 false 120 105 90 180
Line -16777216 false 150 135 150 165
Polygon -2674135 true false 100 30 104 44 189 24 185 10 173 10 166 1 138 -1 111 3 109 28

person police
false
0
Polygon -1 true false 124 91 150 165 178 91
Polygon -13345367 true false 134 91 149 106 134 181 149 196 164 181 149 106 164 91
Polygon -13345367 true false 180 195 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285
Polygon -13345367 true false 120 90 105 90 60 195 90 210 116 158 120 195 180 195 184 158 210 210 240 195 195 90 180 90 165 105 150 165 135 105 120 90
Rectangle -7500403 true true 123 76 176 92
Circle -7500403 true true 110 5 80
Polygon -13345367 true false 150 26 110 41 97 29 137 -1 158 6 185 0 201 6 196 23 204 34 180 33
Line -13345367 false 121 90 194 90
Line -16777216 false 148 143 150 196
Rectangle -16777216 true false 116 186 182 198
Rectangle -16777216 true false 109 183 124 227
Rectangle -16777216 true false 176 183 195 205
Circle -1 true false 152 143 9
Circle -1 true false 152 166 9
Polygon -1184463 true false 172 112 191 112 185 133 179 133
Polygon -1184463 true false 175 6 194 6 189 21 180 21
Line -1184463 false 149 24 197 24
Rectangle -16777216 true false 101 177 122 187
Rectangle -16777216 true false 179 164 183 186

person service
false
0
Polygon -7500403 true true 180 195 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285
Polygon -1 true false 120 90 105 90 60 195 90 210 120 150 120 195 180 195 180 150 210 210 240 195 195 90 180 90 165 105 150 165 135 105 120 90
Polygon -1 true false 123 90 149 141 177 90
Rectangle -7500403 true true 123 76 176 92
Circle -7500403 true true 110 5 80
Line -13345367 false 121 90 194 90
Line -16777216 false 148 143 150 196
Rectangle -16777216 true false 116 186 182 198
Circle -1 true false 152 143 9
Circle -1 true false 152 166 9
Rectangle -16777216 true false 179 164 183 186
Polygon -2674135 true false 180 90 195 90 183 160 180 195 150 195 150 135 180 90
Polygon -2674135 true false 120 90 105 90 114 161 120 195 150 195 150 135 120 90
Polygon -2674135 true false 155 91 128 77 128 101
Rectangle -16777216 true false 118 129 141 140
Polygon -2674135 true false 145 91 172 77 172 101

person soldier
false
0
Rectangle -7500403 true true 127 79 172 94
Polygon -10899396 true false 105 90 60 195 90 210 135 105
Polygon -10899396 true false 195 90 240 195 210 210 165 105
Circle -7500403 true true 110 5 80
Polygon -10899396 true false 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Polygon -6459832 true false 120 90 105 90 180 195 180 165
Line -6459832 false 109 105 139 105
Line -6459832 false 122 125 151 117
Line -6459832 false 137 143 159 134
Line -6459832 false 158 179 181 158
Line -6459832 false 146 160 169 146
Rectangle -6459832 true false 120 193 180 201
Polygon -6459832 true false 122 4 107 16 102 39 105 53 148 34 192 27 189 17 172 2 145 0
Polygon -16777216 true false 183 90 240 15 247 22 193 90
Rectangle -6459832 true false 114 187 128 208
Rectangle -6459832 true false 177 187 191 208

person student
false
0
Polygon -13791810 true false 135 90 150 105 135 165 150 180 165 165 150 105 165 90
Polygon -7500403 true true 195 90 240 195 210 210 165 105
Circle -7500403 true true 110 5 80
Rectangle -7500403 true true 127 79 172 94
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Polygon -1 true false 100 210 130 225 145 165 85 135 63 189
Polygon -13791810 true false 90 210 120 225 135 165 67 130 53 189
Polygon -1 true false 120 224 131 225 124 210
Line -16777216 false 139 168 126 225
Line -16777216 false 140 167 76 136
Polygon -7500403 true true 105 90 60 195 90 210 135 105

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

road
true
0
Rectangle -7500403 true true 0 0 300 300
Rectangle -1 true false 0 75 300 225

road-middle
true
0
Rectangle -7500403 true true 0 0 300 300
Rectangle -10899396 true false 0 45 300 255

road2
true
0
Rectangle -7500403 true true 0 0 300 300
Rectangle -1 true false 60 255 225 390

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

tile stones
false
0
Polygon -7500403 true true 0 240 45 195 75 180 90 165 90 135 45 120 0 135
Polygon -7500403 true true 300 240 285 210 270 180 270 150 300 135 300 225
Polygon -7500403 true true 225 300 240 270 270 255 285 255 300 285 300 300
Polygon -7500403 true true 0 285 30 300 0 300
Polygon -7500403 true true 225 0 210 15 210 30 255 60 285 45 300 30 300 0
Polygon -7500403 true true 0 30 30 0 0 0
Polygon -7500403 true true 15 30 75 0 180 0 195 30 225 60 210 90 135 60 45 60
Polygon -7500403 true true 0 105 30 105 75 120 105 105 90 75 45 75 0 60
Polygon -7500403 true true 300 60 240 75 255 105 285 120 300 105
Polygon -7500403 true true 120 75 120 105 105 135 105 165 165 150 240 150 255 135 240 105 210 105 180 90 150 75
Polygon -7500403 true true 75 300 135 285 195 300
Polygon -7500403 true true 30 285 75 285 120 270 150 270 150 210 90 195 60 210 15 255
Polygon -7500403 true true 180 285 240 255 255 225 255 195 240 165 195 165 150 165 135 195 165 210 165 255

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

waitpoint
false
14
Rectangle -16777216 true true 15 15 285 285
Rectangle -7500403 true false 30 30 270 270

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
NetLogo 5.2.0
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
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
