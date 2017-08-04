;; Members: Abhinav Swaminathan, Samuel Woods ;;
;; Date Created: 03/21/2017 ;;
;; Last Updated: 04/27/2017 ;;
;; Attribution: Felsen, M. and Wilensky, U. (2007). NetLogo Urban Suite - Economic Disparity model. http://ccl.northwestern.edu/netlogo/models/UrbanSuite-EconomicDisparity. Center for Connected Learning and Computer-Based Modeling, Northwestern University, Evanston, IL.

;ai20170430 This is a nice summary statement, right up front, of objectives and findings.
;  You should add a more detailed statement to the `Info` tab.  Also, try to write
;  your comments with shorter lines.  (A maximum of 80 characters is a good guideline.)
;  See the project guidelines.
;ai20170430 I'm not seeing any test procedures??  (See the project guidelines and class discussion.)
;ai20170430 Please make more helpful comments when committing to subversion.  (More like  your project
;  notes at the end of your code.)
;ai20170430 Remember, although the rest of your code is joint, your experiments must be individual.
;  Each of you should label your personal experiments with your initials (in the experiment name).
;  See the project guidelines.

;; Objective: this extension of the Economic Disparity model by Felsen, M. and Wilensky, U. aims to illustrate the phenomenon of food-deserts adversely effecting
;; poor people in greater proportion to rich people, due to the same dynamics and motives between job creation and supermarket creation. Eventually, we show that
;; as they are both profit-seeking, and both move towards areas of wealth, this phenomenon holds true.

;; Notice the plots, under normal parameterization, and as expected with the research and emergences, rich should eventually have a lower traveling distance to both
;; jobs and supermarkets, should in the long run have a greater level of health, and should have less of their members in food deserts than those same conditions of
;; the poor.

;ai20170430 While GUI considerations are largely secondary, I like these choices for visualization!
;; In the default view, a pcolor of yellow indicates that the patch is indeed in a food desert, a pcolor of green indicates the contrary.

;; BehaviorSpace tests are configured to test distance from supermarkets, health, and number affected by food desert of rich and poor



;ai20170430 It is helpful to me if you initial your comments.
; (See the project guidelines.) This can also be helpful to you.
breed [ rich a-rich ] ; create breed of rich agents
breed [ poor a-poor ] ;create breed of poor agent
breed [ jobs job ] ;our jobs breed, agent will behave just as it does in the original UrbanSuite model
breed [supermarkets supermarket] ;;our supermarket breed, in general it will look to spawn in neighborhoods with lots of rich agents, simulating profit-maximizing behavior



;ai20170430 Helpful comments!
rich-own [
utility-r ;the utility of rich agents, as defined by the patch they are on, explained below
closest ;the supermarket that is closest to the agent at a given time
health] ; the health score of the rich agent, meant to simulate nutritional status at a given time
poor-own [
utility-p ;the utility of rich agents, as defined by the patch they are on, explained below
closest ;the supermarket that is closest to the agent at a given time
health] ; the health score of the rich agent, meant to simulate nutritional status at a given
jobs-own [utility] ;the utility of a given job agent, defined by number of rich agents in area
supermarkets-own [utility] ; ;the utility of a given job agent, defined by number of rich agents in area
patches-own [
quality ;perceived quality of the patch, as defined by the original UrbanSuite model
price ; price of the patch, as defined by the original UrbanSuite model
sd-dist ;distance to the closest supermarket agent
sd-dist-jobs ;distance to the closest job agent
inDesert] ;boolean variable to determine if patch is in a food desert or not
;ai20170410: please state the type and purpose of every variable
globals [
  counter
  View-mode ;
  min-poor-util ;the minimum amount of utility a poor agent may have
  max-poor-util ; the maximum amount of utility a poor agent may have
  min-rich-util ; the minimum amount of utility a rich agent may have
  max-rich-util ; the maximum amount of utility a rich agent may have
  death-rate
  ]

;;
;; Setup Procedures
;;

to setup
  clear-all
  set view-mode "desert"
  set death-rate 4
;;since this model is oriented toward food deserts and not jobs as in orginal model, we
;;want our view our view to reflect where the deserts are
  setup-supermarkets
  setup-jobs
  setup-patches
  setup-rich
  setup-poor
  locate-inDesert
  ask patches [update-patch-color]
  reset-ticks
end

;ai20170430 It is good practice to separate out all the GUI code
;  (e.g., into `setupGUI` and `updateGUI`).  The original model
;  made a good start on this; you should push it further.

to setup-jobs
;;the following procedure creates one starting job in a random place on the map. The
;;presence of the job agent in an area raises the price and quality of the area, simulating
;;the perceived benefit of living closer to where one works
  create-jobs 1 [
  setxy random-xcor random-ycor
  set shape "circle"
  set color red
  set size 2
  raise-price
  raise-value
  ]
end

to setup-patches
;;initializes the patches’ attributes
  ask patches [
    set quality 40
    set price 40
  ]
  ask patches
  [
    set sd-dist min [distance myself] of supermarkets
    set sd-dist-jobs min [distance myself] of jobs
  ]
end

;ai20170430 I'm not going to comment on them individually, for the most part,
;  but I must say that the comments summarizing the procedures take a really
;  good approach.  Many groups added line by line comments that essentially
;  restated the code, which the project guidelines explicitly discouraged.
;  Your approach is much more helpful!  (Additionally, you generally use short
;  enough lines to prevent comment wrapping; a good practice!)
to setup-rich
;;creates 5 rich agents, the agents raise the quality and price of the area (patches) they are
;;placed on, simulating market forces’ effect on the price of land and the perceived quality
;;of land in a predominantly rich area
  create-rich 5
  ask rich
  [
    set color 126
    set shape "box"
    let radius 10
    setxy ( ( radius / 2 ) - random-float ( radius * 1.0 ) ) ( ( radius / 2 ) - random-float ( radius * 1.0 ) )
    raise-price
    raise-value
  ]
end

to setup-poor
;;as opposed to rich agents, poor agents decrease the price and value of the land
;;(patches) they inhabit, simulating market forces’ effect on price and the perceived quality
;;of land/homes in poorer neighborhoods
  create-poor 5
  ask poor
  [
    set color 105
    set shape "box"
    let radius 10
    setxy ( ( radius / 2 ) - random-float ( radius * 1.0 ) ) ( ( radius / 2 ) - random-float ( radius * 1.0 ) )
    decrease-price
    decrease-value
  ]

end

to decrease-value ;;copied from the original UrbanSuite model
;;as one can see, de-valuing the quality of a given patch also has de-valuing effects for the
;;patches around it, simulating the desire for people in the real world to not live close to
;;something that de-values their home/land
  ask patch-here [ set quality ( quality * 0.95 ) ]
  ask patches in-radius 1 [ set quality ( quality * 0.96 ) ]
  ask patches in-radius 2 [ set quality ( quality * 0.97 ) ]
  ask patches in-radius 3 [ set quality ( quality * 0.98 ) ]
  ask patches in-radius 4 [ set quality ( quality * 0.99 )
    if (quality < 1) [ set quality 1]
  ]
end

to raise-price ;;copied from the original UrbanSuite model
;;when a rich agent moves to a patch, it is assumed that they have driven the price of that
;;patch up. As with quality, this change in price affects the price of the land/homes
;;(patches) that surround this patch
  ask patch-here [ set price ( price * 1.05 ) ]
  ask patches in-radius 1 [ set price ( price * 1.04 ) ]
  ask patches in-radius 2 [ set price ( price * 1.03 ) ]
  ask patches in-radius 3 [ set price ( price * 1.02 ) ]
  ask patches in-radius 4 [ set price ( price * 1.01 )]
   if price > 100 [ set price 100 ]
end

to raise-value ;;copied from the original UrbanSuite model
;;similar to the rational for raising price, a patch’s quality is raised when a rich agent moves
;;to it, a job is nearby, or a supermarket is nearby.
  ask patch-here [ set quality ( quality * 1.05 ) ]
  ask patches in-radius 1 [ set quality ( quality * 1.04 ) ]
  ask patches in-radius 2 [ set quality ( quality * 1.03 ) ]
  ask patches in-radius 3 [ set quality ( quality * 1.02 ) ]
  ask patches in-radius 4 [ set quality ( quality * 1.01 )
    if quality > 100 [ set quality 100 ]
  ]
end

to decrease-price ;procedure to decrease the price of the specific patch and the patches within the radius of 4 of that patch.
;;copied from the original UrbanSuite model
;;as with quality, de-valuing the quality of a given patch also has de-valuing effects for the
;;prices of patches around it, simulating the effect that a drop in perceived value has on an
;;property’s price
  ask patch-here [ set price ( price * 0.95 ) ]
  ask patches in-radius 1 [ set price ( price * 0.96 ) ]
  ask patches in-radius 2 [ set price ( price * 0.97 ) ]
  ask patches in-radius 3 [ set price ( price * 0.98 ) ]
  ask patches in-radius 4 [ set price ( price * 0.99 )
    if (price < 1) [ set price 1]
  ]
end

to setup-supermarkets ;procedure to setup supermarkets
  create-supermarkets 1
  ask supermarkets
  [
    set color blue
    set shape "box"
    setxy ( ( 50 / 2 ) - random-float ( 50 * 1.0 ) ) ( ( 49 / 2 ) - random-float ( 49 * 1.0 ) )
    set size 3
    raise-price
    raise-value
  ]
end

;;
;; Runtime Procedures
;;


to locateClosest ;rich/poor agent procedure, instructs agents to find the closest supermarket
  let _close min-one-of supermarkets in-radius 10 [distance myself]
  set closest _close
end

to go ;runtime procedure.
  if ticks > 120 [stop] ;;simulates 10 years where 1 tick = 1 month
  locate-poor
  locate-rich
  if counter > residents-per-job
  [
    locate-service
    locate-supermarkets
    set counter 0
  ]

  ask rich [locateClosest]
  ask poor [locateClosest]
  update-health
  if count (rich) >= 20 [kill-rich]
  if count (poor) >= 20 [kill-poor]
  if count (jobs) >= max-jobs [kill-service]
  if count (supermarkets) >= max-supermarkets [kill-supermarkets]
  locate-inDesert
  update-view
  tick
end


to locate-inDesert ;locate the specific patches that are within radius 10 or 1 sq mile of a supermarket
  ask patches [
   ifelse (any? supermarkets in-radius 10) [set inDesert false][set inDesert true]
  ]
end

to locate-poor ;procedure to create and act on new poor agents.
  set counter ( counter + poor-per-step )
  create-poor poor-per-step
  [
    set color 105
    set shape "box"
    evaluate-poor
    decrease-value
    decrease-price
  ]
end

to locate-rich ;; copied from the original UrbanSuite model, procedure to create and act on new rich agents.
  set counter ( counter + rich-per-step )
  create-rich rich-per-step
  [
    set color 126
    set shape "box"
    evaluate-rich
    raise-price
    raise-value

  ]
end

to evaluate-poor ;;copied from the original UrbanSuite model. procedure to find the best patch for a poor agent to move to
  let candidate-patches n-of number-of-tests patches
  set candidate-patches candidate-patches with [ not any? turtles-here ]
  if (not any? candidate-patches)
    [ stop ]

  ;; we use a hedonistic utility function for our agents, shown below (comment from original model)
  ;; basically, poor people are looking for inexpensive real estate, close to jobs
  let best-candidate max-one-of candidate-patches
    [ patch-utility-for-poor ]
  move-to best-candidate
  set utility-p [ patch-utility-for-poor ] of best-candidate
end

to-report patch-utility-for-poor
;;inspired by the original UrbanSuite model, but we have added a consideration for health
;;at the end, and distinguish between distance to a job and distance to supermarkets
    report ( ( 1 / (sd-dist-jobs / 100 + 0.1) ) ^ ( 1 + poor-price-priority ) ) * ( ( 1 / price ) ^ ( 1 + poor-price-priority ) * (1 / sd-dist / 100 + 0.1) ^ (1 + poor-health-priority))
end

to evaluate-rich
;;copied from the original UrbanSuite model - procedure to evaluate best patches for rich
;;to move to
  let candidate-patches n-of number-of-tests patches
  set candidate-patches candidate-patches with [ not any? turtles-here ]
  if (not any? candidate-patches)
    [ stop ] ;;if there are no patches in the number of tests that have no turtles here, stop the simulation

  let best-candidate max-one-of candidate-patches
        [ patch-utility-for-rich ]
  move-to best-candidate ;move to the best candidate for rich to move to
  set utility-r [ patch-utility-for-rich ] of best-candidate ;reset utility to that of best candidate
end

to-report patch-utility-for-rich ;procedure to report the patch utility for rich agents
;;inspired by the original UrbanSuite model, but we have added a consideration for health
;;at the end, and distinguish between distance to a job and distance to supermarkets
  report ( ( 1 / (sd-dist-jobs + 0.1) ) ^ ( 1 + rich-quality-priority ) ) * ( quality ^ ( 1 + rich-quality-priority)) * ( 1 / sd-dist + 0.1) ^ (1 + rich-health-priority)
end

to kill-poor
;;copied from original UrbanSuite modelprocedure to kill poor agents (follows same logic
;;as kill-rich procedure below)
;  repeat ( death-rate + mean [mortality] of patches with [mortality > 0.5])
  repeat (death-rate)
  [
    ;always kill the person that's been around the longest
    ask min-one-of poor [who]
      [ die ]
  ]
end

to kill-rich ;procedure to kill rich agents ;;copied from original UrbanSuite model
  repeat ( death-rate ) ;repeat for amount of agents in death-rate
  [
    ;always kill the person that's been around the longest
    ask min-one-of rich [who]
      [ die ] ;ask the oldest one to die
  ]
end

to update-health ;procedure to update the health turtle attribute
  ask rich [
    if any? supermarkets in-radius 10 [set health health + 1] ;ask the rich in non-food deserts to increment health by 1
    if count supermarkets in-radius 10 < 1 [set health health - 1] ;ask the rich in food deserts to decrement health by 1
   ]
  ask poor [
    if any? supermarkets in-radius 10 [set health health + 1] ;ask the poor in non-food deserts to increment health by 1
    if count supermarkets in-radius 10 < 1 [set health health - 1] ;ask the poor in food deserts to decrement health by 1
  ]
end

to kill-service ;;copied from teh original UrbanSuite model - procedure to kill a job
  ; always kill the oldest job (original author comment)
  ask min-one-of jobs [who] ;ask the oldest job to
    [ die ] ;terminate from the simulation
  ask patches
    [ set sd-dist-jobs min [distance myself + .01] of jobs ] ;set new sd-dst of jobs to new arrangement of jobs.
end

to locate-service ;procedure to create and assess distance of new jobs
  let empty-patches patches with [ not any? turtles-here ] ;ask patches with no turtles there

  if any? empty-patches
  [
    ask one-of empty-patches ;ask one of the empty patches with no turtles there to
    [
      sprout-jobs 1 ;create a new job agent
      [
        set color red
        set shape "circle"
        set size 2
        evaluate-job
      ]
    ]
    ask patches
      [ set sd-dist-jobs min [distance myself + .01] of jobs ] ;set new value for sd-dist-jobs to track to new supermarkets
  ]
end

to evaluate-job
;;from original urbanSuite Model - procedure to evaluate patches for job creation and
;;moving.
  let candidate-patches n-of number-of-tests patches
  set candidate-patches candidate-patches with [ not any? turtles-here ]
  if (not any? candidate-patches)
    [ stop ]
;;all comments below are from original author
;
;  ;; In this model, we assume that jobs move toward where the money is.
;  ;; The validity of this assumption in a real-world setting is worthy of skepticism.
;  ;;
;  ;; However, it may not be entirely unreasonable. For instance, places with higher real
;  ;; estate values are more likely to have affluent people nearby that will spend money
;  ;; at retail commercial shops.
;  ;;
;  ;; On the other hand, companies would like to pay less rent, and so they may prefer to buy
;  ;; land at low real-estate values
;  ;; (particularly true for industrial sectors, which have no need for consumers nearby)
  let best-candidate max-one-of candidate-patches [ price ]
  move-to best-candidate ;move to the best job candidate patch
  set utility [ price ] of best-candidate ;set the utility to the price of the best candidate patch for jobs
  raise-price ; ask the job to raise the price of the patch they reside on
  raise-value ; ask the job to raise the value of the patch they reside on
end

to kill-supermarkets ;;copied from original UrbanSuite model - procedure to destroy supermarkets.
  ; always kill the oldest supermarket (original comment)
  ask min-one-of supermarkets [who] ;ask the oldest supermarket to
    [ die ] ;be removed from the simulation
  ask patches
    [ set sd-dist min [distance myself + .01] of supermarkets ] ;set new sd-dist from the new set of supermarkets.
end

to locate-supermarkets ;;Original model procedure - create and assess distance from supermarkets
  let empty-patches patches with [ not any? turtles-here ]

  if any? empty-patches ;check for empty patches
 [
    ask one-of empty-patches ;ask one of the empty patches to:
    [
      sprout-supermarkets 1 ;create new supermarket
      [
        set color blue
        set shape "box"
        set size 3
        evaluate-supermarkets ;evaluate new candidate patches.
      ]
    ]
    ask patches
      [ set sd-dist min [distance myself + .01] of supermarkets ] ;increment sd-dist
  ]
end

;ai20170430 Please try to add your initials to your comments.
;  (But I did see your note that you worked on these together.)
;ai20170430 It is good that the first comment cites the code it derives from,
;  but it could mislead the reader to think there are supermarkets in the original.
to evaluate-supermarkets ;;orginal UrbanSuite model - procedure to pick best area to move for supermarkets
  ;ai20170430 the next comment is misleading since *that line* only choose patches to test
  let candidate-patches n-of number-of-tests patches ;test number of tests patches for certain conditions.
  set candidate-patches candidate-patches with [ not any? turtles-here ] ;find empty plots
  if (not any? candidate-patches)
    ;ai20170430 This will not stop the simulation but rather exit the procedure.
    [ stop ] ;if there are no suitable patches in which there are no turtles, stop the simulation.

  let best-candidate max-one-of candidate-patches [ price ] ;supermarkets track towards wealth of area.
  move-to best-candidate ;move to the best candidate patch.
  set utility [ price ] of best-candidate ;change utility of patch to the price of the best candidate patch.
end

;ai20170430 Note that you can just put `count supermarkets` wherever you put this reporter.
to-report count-supermarkets
  report count supermarkets
end


;;
;; Visualization Procedures
;;

to update-view ;update the viewframe.

  if (view-mode = "poor-utility" or view-mode = "rich-utility") ;conditional for certain (poor-utility/rich-utility) visualizations.
  [
    let poor-util-list [ patch-utility-for-poor ] of patches
    set min-poor-util min poor-util-list
    set max-poor-util max poor-util-list

    let rich-util-list [ patch-utility-for-rich ] of patches
    set min-rich-util min rich-util-list
    set max-rich-util max rich-util-list
  ]

  ask patches [ update-patch-color ] ;ask the patches to update their color
end

to update-patch-color ;procedure for applying different visualizations to the simulation.
  ;; the particular constants we use to scale the colors in the display
  ;; are mainly chosen for visual appeal
  if view-mode = "desert" ;if the user chooses a desert visualization.
  [
    ; use a logarithm for coloring, so we see better gradation
    ifelse (inDesert = true)[set pcolor yellow][set pcolor green] ;ask patches in a food desert to set color to yellow. Ask patches not in food desert to set pcolor to green.
  ]
  ifelse view-mode = "quality" ;if the user chooses a quality visualization
  [
    set pcolor scale-color green quality 1 100 ;scale the color of the patch proportional to the quality of the patch.
  ][
  ifelse view-mode = "price"
  [
    set pcolor scale-color yellow price 0 100 ;scale the color of the patch proportional to the price of the patch
  ][
  ifelse view-mode = "dist"
  [
    set pcolor scale-color blue (sd-dist)  ( 0.45 * ( max-pxcor * 1.414 ) ) ( 0.05 * ( max-pxcor * 1.414 ) ) ;scale the color relative to the distance from a supermarket or job
  ][
  ifelse view-mode = "poor-utility"
  [
    ; use a logarithm for coloring, so we see better gradation
    set pcolor scale-color sky ln patch-utility-for-poor ln min-poor-util ln max-poor-util ;scale the color proportional the the aggregate poor utility
  ][
  ]]]]
end


;; Dev Comments: ;;
;ai20170430 This is a great section of your code!  It documents what you are
;  working on and the decisions you make.  In a more professional project,
;  this would exist in a separate "project notebook".  A really good idea!

;;;so generally, we can sprout a given number of supermarkets as patches in random places across the map
;;;rich and poor will both want to move closer to supermarkets, but rich will be able to afford to move closer or even move at all
;;;at the end, we will (likely) have demonstrated that food deserts arise naturally given that agents are utility maximizers and the interests of rich overtake interests of poor


;;SW 4/20 edits: added (1) a supermarkets breed, (2) a "setup-supermarkets" procedure, (3) changed original GUI title
;;to "Travel Distance to Job", and lastly (4) added a GUI entitled "Travel Distance to Supermarkets", which of course
;;displays the average distance to supermarkets for both rich and poor
;;SW 4/24: added global variable n_supermarkets, defined by a slider in the interface

;;AS 4/23 comments: Perhaps we should replace jobs entirely with supermarkets, as they create/destroy along the same principles.

;;AS 4/26 comments: The addition and subtraction of supermarkets from the model will follow roughly the same behavior as that of jobs,
;; as supermarkets are also inherently profit maximizers, and will move to areas of wealth. We will qualify a 'food desert' as the areas
;; that are at least ____ units in distance from a supermarket. We will quantify the theory that food deserts disproportionately affect
;; constituents of lowersocioeconomic status by introducing a monitor for the amount of 'rich' people that reside in a food desert, and
;; the amount of 'poor' people that reside in a food desert. Another factor to consider, which aids in quantifying this theory is mortility rate.
;; Over time, the average mortility rate of constituents of food deserts will increase, as the cheaper alternative to fresh food that is provided
;; by supermarkets is low-cost, low quality fast food. We predict that by running these extensions to the model under normal
;; parameterization, we can illustrate the aforementioned phenomenon.

;; AS 4/26 comments: Certain base parameters of the model that are dynamic must be changed to static, to accurately model natural
;; phenomenons.

;; AS 4/26 tests: BehaviorSpace is utilized for the purpose of running tests on the simulation. The first test is the correlation between

;; AS 4/26 comments: Considerations for topology. Each patch = 10 sq ft.

;; AS 4/26 comments: More considerations: add alternative to supermarkets which place lower emphasis on utility, and more on volume of suitable
;; customers, and rich/poor-health-priority.

;; AS For 4/27: configure obesity, reconfigure mortality, perhaps add alternative agents, tidy code, comment code, tweak plots.


;; AS 4/27: Topological constraints. 10,000 patches. Every patch represents 1/10 of a sq mile. A radius of 10 around any given patch represents one sq mile.
;; since food deserts are defined as any areas > = one sq mile without access to a supermarket, we will define a food desert as the patches > one sq mile, or
;; 10 patches in radius from any given supermarket. We will then evaluate the proportion of constituents (either poor or rich), that reside within and outside of
;; the 10 patch constraint.

;; AS 4/27: Time constraints. Each tick is one day. We will evaluate over ten years, to retain completeness of the simulation, and relative stochasticity of emergences.

;; AS 4/27: 7:00 PM : things to consider/tweak:
;; 1.) Need to reconsider the logic of incrementing/decrementing obesity.
;; 2.) Need to get rid of mortality completely (unrealistic for time-span / hard to determine)
;; 3.) Need to fix poor-health-priority and rich-health-priority equations in patch-utility-for-rich and patch-price-for poor procedures.
;; 4.) Solidify an amount of visualization options to include and trim the extra conditionals in the (update-patch-color) procedure
;; 5.) Configure view obesity visualization (c&p another visualization conditional in update-patch-color, have it scale color proportional to obesity
;; 6.) Trim the extra commented out code
;; 7.) Fully comment the logic in the code


;;SW 4/27: got rid of mortality, re-configured obesity to be to be an agent attribute an increase by tick, renamed "health"
;;    re-added jobs interaction per phone conversation
;;    cleaned-up some old code


;; AS 4/27: cleaned up GUI and stray code. Added comments to all code with Sam.
@#$#@#$#@
GRAPHICS-WINDOW
350
10
758
419
-1
-1
4.0
1
10
1
1
1
0
0
0
1
-50
49
-50
49
1
1
1
ticks
30.0

BUTTON
60
15
138
48
NIL
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
140
15
216
48
NIL
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
10
140
170
173
number-of-tests
number-of-tests
0
100
92.0
1
1
NIL
HORIZONTAL

PLOT
10
285
335
485
Travel Distance of Residents to all Supermarkets and Jobs
time
# cells
0.0
100.0
0.0
20.0
true
true
"" ""
PENS
"rich-jobs" 1.0 0 -3508570 true "" "plot median [ min [distance myself] of jobs ] of rich"
"poor-jobs" 1.0 0 -14070903 true "" "plot median [ min [distance myself] of jobs ] of poor"
"rich-sm" 1.0 0 -7500403 true "" "plot median [ min [distance myself] of supermarkets ] of rich"
"poor-sm" 1.0 0 -2674135 true "" "plot median [ min [distance myself] of supermarkets ] of poor"

BUTTON
218
15
296
48
go-once
go
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
0

BUTTON
35
60
125
93
view price
set view-mode \"price\"\nupdate-view
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
0

BUTTON
130
60
220
93
view quality
set view-mode \"quality\"\nupdate-view
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
0

SLIDER
10
175
170
208
residents-per-job
residents-per-job
0
500
500.0
10
1
NIL
HORIZONTAL

SLIDER
175
210
335
243
poor-per-step
poor-per-step
0
15
5.0
1
1
NIL
HORIZONTAL

SLIDER
175
245
335
278
rich-per-step
rich-per-step
0
15
15.0
1
1
NIL
HORIZONTAL

SLIDER
175
140
335
173
poor-price-priority
poor-price-priority
-1
1
0.0
.1
1
NIL
HORIZONTAL

SLIDER
175
175
335
208
rich-quality-priority
rich-quality-priority
-1
1
-0.6
0.1
1
NIL
HORIZONTAL

MONITOR
450
425
525
470
population
count poor + count rich
17
1
11

MONITOR
535
425
610
470
poor pop
count poor
17
1
11

MONITOR
615
425
690
470
rich pop
count rich
17
1
11

MONITOR
345
425
445
470
# of supermarkets
count-supermarkets
17
1
11

SLIDER
10
245
170
278
max-supermarkets
max-supermarkets
0
50
10.0
1
1
NIL
HORIZONTAL

SLIDER
10
105
170
138
poor-health-priority
poor-health-priority
-1
1
1.0
0.1
1
NIL
HORIZONTAL

SLIDER
175
105
335
138
rich-health-priority
rich-health-priority
0
1
1.0
0.1
1
NIL
HORIZONTAL

BUTTON
225
60
327
93
view Desert
set view-mode \"desert\"\nupdate-view
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

PLOT
765
10
1115
190
Health
NIL
NIL
0.0
10.0
0.0
10.0
true
true
"" ""
PENS
"poor" 1.0 0 -16777216 true "" "plot mean [health] of poor"
"rich" 1.0 0 -7500403 true "" "plot mean [health] of rich"

PLOT
765
195
1115
375
Poor v Rich people in Food Deserts
NIL
NIL
0.0
10.0
0.0
10.0
true
true
"" ""
PENS
"rich" 1.0 0 -11053225 true "" "plot count patches with [inDesert = true] with [any? rich-here]\n"
"poor" 1.0 0 -16777216 true "" "plot count patches with [inDesert = true] with [any? poor-here]\n"

SLIDER
10
210
170
243
max-jobs
max-jobs
0
10
10.0
1
1
NIL
HORIZONTAL

MONITOR
695
425
762
470
# of jobs
count jobs
17
1
11

@#$#@#$#@
## YOUR INFO TAB

;ai20170430 You should add your own model documentation here!

## WHAT IS IT?

This model explores residential land-usage patterns from an economic perspective, using the socio-economic status of the agents to determine their preferences for choosing a location to live.  It models the growth of two populations, one rich and one poor, who settle based on three properties of the landscape: the perceived quality, the cost of living, and the proximity to services (large red dots). These same properties then change based on where the different populations settle.

The model ultimately shows the segregation of populations based on income, the clustering of services in more affluent areas, and how people's attitude can lead either to a cluster condition (emphasis on proximity), or a condition of sprawl (emphasis on cost or quality).

## HOW IT WORKS

Job sites (shown as red circles on the map) are created and destroyed.  People (shown as small blue and pink squares) move in and move out.  These people want to live near to jobs, but also consider the price (cost of living) and quality of prospective locations.  But let's get more specific.

When a new place of employment comes into the world, it randomly samples some number of locations (controlled by the NUMBER-OF-TESTS slider), and chooses the one with the highest price (i.e. land-value).  This may seem irrational at first, but the assumption this model makes is that jobs move toward where the wealth is.  If there is more money in a certain area, then there are more affluent people to spend that money on goods and services.

The validity of this assumption in a real-world setting is worthy of skepticism.  For instance, companies also wish to pay less rent or property tax, and so alternatively one could argue that they would be seeking the least expensive piece of land to occupy.  This seems particularly true for the industrial sector, which has no need for consumers to be nearby.

In any case, the reader is encouraged to carefully examine all assumptions, challenge them, and perhaps extend the model to incorporate assumptions that are more plausible in his/her view.  A model's predictions are only as good as the assumptions that underlie them.

Each "tick" of the model, some number of new poor people (controlled by the POOR-PER-STEP slider) and new rich people (controlled by the RICH-PER-STEP slider) enter into the world.  When people enter the world, they randomly sample some number of locations, and choose to inhabit the one that maximizes "utility" for them, which is given by a hedonistic utility function.

There are two fundamentally different types of people in this model -- "poor" people (shown in blue) and "rich" people (shown in pink), and they have differing priorities.  Both types of people wish to be located close to a place of employment.  However, rich people seek a location that has good quality, heedless of price, whereas poor people seek locations with low price, disregarding quality.

The last important rule of the model is the effect that agents have on the land they inhabit.  Rich people moving into an area cause the land price and quality to increase, whereas poor people cause the land price and quality to decrease.  Nearby land attributes are affected as well, with the effect diminishing over distance.

## HOW TO USE IT

Click the SETUP button first, to set up the model.  All land in the world has the same price and quality.  One job location is placed in the middle of the world, and several rich and poor people are spread out nearby it, which immediately affect the quality and price of the land they inhabit, as well as nearby land.

Click the GO button to start the simulation.  To step through the simulation one "tick" at a time, use the GO-ONCE button.

There are five view modes, which are controlled by the buttons VIEW PRICE, VIEW QUALITY, VIEW DIST., VIEW RICH-UTILITY, and VIEW-POOR-UTILITY

VIEW PRICE displays the land-price value of each location, with white being a high price, black being a low price, and the various shades of yellow are in between.

VIEW QUALITY displays the quality value of each location, with white being a high quality, black being a low quality, and the various shades of green are in between.

VIEW DIST. displays the distance from each location to a place of employment.  Brighter colors demonstrate closeness.

VIEW RICH-UTILITY displays the utility that rich people assign to each location on the map.  Lighter values designate better utility, and darker values designate worse utility.  Note that the highest utility areas may still be vacant, since each agent only samples a small set of the patches in the world

VIEW-POOR-UTILITY displays the utility that poor people assign to each location on the map.  Lighter values designate better utility, and darker values designate worse utility.

The NUMBER-OF-TESTS slider affects how many locations each agent looks at when choosing a location that optimizes the agent's utility.

The RESIDENTS-PER-JOB slider determines how often a new place of employment is created in the world.  For every RESIDENTS-PER-JOB people, a new place of employment appears.

There is,  however,  a maximum number of places of employment, which is controlled by the MAX-JOBS slider.

Some number of poor people enter the world each time step, as determined by the POOR-PER-STEP slider.  Likewise, some number of rich people (determined by the RICH-PER-STEP slider) enter the world.

Some number of poor people and rich people disappear from the world each turn, as well, which is determined by the DEATH-RATE slider.  Although it is called "death rate", it should not be taken literally -- it merely represents the disappearance of agents from the world that is being considered by the model, which could be caused by a number of factors (such as emigration).  If DEATH-RATE is set to 5, this means that both 5 rich people and 5 poor people disappear each time step.  The agents removed are always those that have been in the world for the longest period of time.

The priorities of the poor people can be adjusted with the POOR-PRICE-PRIORITY slider.  If this slider is set to -1, this means that poor people do not care about price at all, and are only interested in being close to employment.  If this slider is set to 1, then poor people only care about price, and do not concern themselves with job locations.  Setting the slider at 0 balances these two factors.

Similarly, the priorities of rich people can be adjusted with the RICH-QUALITY-PRIORITY slider.  On this slider, -1 means that rich people care only about having a short commute to their jobs, and not about the quality of the land, whereas 1 means that they care only about quality, and are not concerned with distance to employment.  Again, 0 represents an equal balance of these priorities.

The TRAVEL DISTANCE plot shows the average distance that poor and rich people must travel to reach the nearest point of employment.  Apart from the interesting visual patterns that form in the view, this plot is the most important output of the model.

The # OF JOBS monitor tells how many places of employment are currently in the world.

The POPULATION monitor tells how many total people there are in the world, and the POOR POP and RICH POP monitors give the poor and rich population sizes respectively.

## THINGS TO NOTICE

Do the VIEW PRICE mode and the VIEW QUALITY mode look very similar?  Apart from the fact that one is green, and the other is yellow, they might be showing identical values?  To test this, you can right click (or control-click on a Mac computer) on one of the patches in the view and choose "inspect patch XX YY".  You can do this for several patches, and you will find that the price and quality are always the same.  In this model, whenever quality goes up or down, price changes in direct proportion.

What if NUMBER-OF-TESTS is small?  Is the population more or less densely centered around the jobs?  What if NUMBER-OF-TESTS is large?

Change the viewing mode to distance-from-jobs, by clicking the VIEW DIST button.  Watch the model run, and the lines that form where gradients from two different jobs come together and overlap.  These shapes are related to Voronoi polygons.  You can learn more about them by looking at the "Voronoi" model in the NetLogo model library.

Even if the DEATH-RATE is set such that more people are leaving the world than entering it, the model does not allow the population to die out entirely -- instead, the population will stay small.  If you grow the population for a while, and then raise the DEATH-RATE to balance out rich and poor people entering the world, then you can hold the population constant.  In this case, you might view the scenario as the same people relocating within the model, rather than new people entering and old people leaving.

## THINGS TO TRY

After letting the model run for a while, try switching back and forth between the VIEW POOR-UTILITY and VIEW RICH-UTILITY display modes.  How many places that are dark for rich are bright for poor?  Is there usually an inverse relationship?  Are there places which both rich and poor find desirable, and if so, where are they?  What if you move both priority sliders to the left?

Try drastically changing the POOR-PRICE-PRIORITY and RICH-QUALITY-PRIORITY sliders.  Do rich people always have the shorter distances to employment, or do poor people sometimes have the shorter distances?

## EXTENDING THE MODEL

As noted above in the THINGS TO NOTICE section, in this model price and quality of land are locked together, always holding the same values.  Extend this model so that this isn't always the case.  For example, you might make it so that when new people move into an area of the model, they only affect the quality of nearby locations in a small radius, whereas they affect the price of a broader circle of cells.

## NETLOGO FEATURES

This model makes use of NetLogo's breeds to differentiate rich agents, poor agents, and job agents.

Extensive use is also made of the SCALE-COLOR primitive, which allows for the three different view modes of the model.

## RELATED MODELS

This model is related to all of the other models in the "Urban Suite".  In particular, this model shows elements of the concept of positive feedback, which is demonstrated in the "Urban Suite - Positive Feedback" model.

It might also be interesting to compare it to the models "Wealth Distribution" and "Voronoi".

## CREDITS AND REFERENCES

This model was loosely based on a model originally written by William Rand and Derek Robinson as part of the Sluce Project at the University of Michigan.  For more about the original model (SOME) that was the basis for this model, please see:

Brown D.G., Robinson D.T., Nassauer J.I., An L., Page S.E., Low B., Rand W., Zellner M., and R. Riolo (In Press) "Exurbia from the Bottom-Up: Agent-Based Modeling and Empirical Requirements." Geoforum.

This model was developed during the Sprawl/Swarm Class at Illinois Institute of Technology in Fall 2006 under the supervision of Sarah Dunn and Martin Felsen, by the following group of students: Danil Nagy and Bridget Dodd.  See http://www.sprawlcity.us/ for more details.

Further modifications and refinements were made by members of the Center for Connected Learning and Computer-Based Modeling before releasing it as an Urban Suite model.

The Urban Suite models were developed as part of the Procedural Modeling of Cities project, under the sponsorship of NSF ITR award 0326542, Electronic Arts & Maxis.

Please see the project web site ([http://ccl.northwestern.edu/cities/](http://ccl.northwestern.edu/cities/)) for more information.

## HOW TO CITE

If you mention this model or the NetLogo software in a publication, we ask that you include the citations below.

For the model itself:

* Felsen, M. and Wilensky, U. (2007).  NetLogo Urban Suite - Economic Disparity model.  http://ccl.northwestern.edu/netlogo/models/UrbanSuite-EconomicDisparity.  Center for Connected Learning and Computer-Based Modeling, Northwestern University, Evanston, IL.

Please cite the NetLogo software as:

* Wilensky, U. (1999). NetLogo. http://ccl.northwestern.edu/netlogo/. Center for Connected Learning and Computer-Based Modeling, Northwestern University, Evanston, IL.

## COPYRIGHT AND LICENSE

Copyright 2007 Uri Wilensky.

![CC BY-NC-SA 3.0](http://ccl.northwestern.edu/images/creativecommons/byncsa.png)

This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 3.0 License.  To view a copy of this license, visit https://creativecommons.org/licenses/by-nc-sa/3.0/ or send a letter to Creative Commons, 559 Nathan Abbott Way, Stanford, California 94305, USA.

Commercial licenses are also available. To inquire about commercial licenses, please contact Uri Wilensky at uri@northwestern.edu.

<!-- 2007 Cite: Felsen, M. -->
@#$#@#$#@
default
true
0
Polygon -7500403 true true 150 5 40 250 150 205 260 250

ant
true
0
Polygon -7500403 true true 136 61 129 46 144 30 119 45 124 60 114 82 97 37 132 10 93 36 111 84 127 105 172 105 189 84 208 35 171 11 202 35 204 37 186 82 177 60 180 44 159 32 170 44 165 60
Polygon -7500403 true true 150 95 135 103 139 117 125 149 137 180 135 196 150 204 166 195 161 180 174 150 158 116 164 102
Polygon -7500403 true true 149 186 128 197 114 232 134 270 149 282 166 270 185 232 171 195 149 186
Polygon -7500403 true true 225 66 230 107 159 122 161 127 234 111 236 106
Polygon -7500403 true true 78 58 99 116 139 123 137 128 95 119
Polygon -7500403 true true 48 103 90 147 129 147 130 151 86 151
Polygon -7500403 true true 65 224 92 171 134 160 135 164 95 175
Polygon -7500403 true true 235 222 210 170 163 162 161 166 208 174
Polygon -7500403 true true 249 107 211 147 168 147 168 150 213 150

arrow
true
0
Polygon -7500403 true true 150 0 0 150 105 150 105 293 195 293 195 150 300 150

bee
true
0
Polygon -1184463 true false 151 152 137 77 105 67 89 67 66 74 48 85 36 100 24 116 14 134 0 151 15 167 22 182 40 206 58 220 82 226 105 226 134 222
Polygon -16777216 true false 151 150 149 128 149 114 155 98 178 80 197 80 217 81 233 95 242 117 246 141 247 151 245 177 234 195 218 207 206 211 184 211 161 204 151 189 148 171
Polygon -7500403 true true 246 151 241 119 240 96 250 81 261 78 275 87 282 103 277 115 287 121 299 150 286 180 277 189 283 197 281 210 270 222 256 222 243 212 242 192
Polygon -16777216 true false 115 70 129 74 128 223 114 224
Polygon -16777216 true false 89 67 74 71 74 224 89 225 89 67
Polygon -16777216 true false 43 91 31 106 31 195 45 211
Line -1 false 200 144 213 70
Line -1 false 213 70 213 45
Line -1 false 214 45 203 26
Line -1 false 204 26 185 22
Line -1 false 185 22 170 25
Line -1 false 169 26 159 37
Line -1 false 159 37 156 55
Line -1 false 157 55 199 143
Line -1 false 200 141 162 227
Line -1 false 162 227 163 241
Line -1 false 163 241 171 249
Line -1 false 171 249 190 254
Line -1 false 192 253 203 248
Line -1 false 205 249 218 235
Line -1 false 218 235 200 144

bird1
false
0
Polygon -7500403 true true 2 6 2 39 270 298 297 298 299 271 187 160 279 75 276 22 100 67 31 0

bird2
false
0
Polygon -7500403 true true 2 4 33 4 298 270 298 298 272 298 155 184 117 289 61 295 61 105 0 43

boat1
false
0
Polygon -1 true false 63 162 90 207 223 207 290 162
Rectangle -6459832 true false 150 32 157 162
Polygon -13345367 true false 150 34 131 49 145 47 147 48 149 49
Polygon -7500403 true true 158 33 230 157 182 150 169 151 157 156
Polygon -7500403 true true 149 55 88 143 103 139 111 136 117 139 126 145 130 147 139 147 146 146 149 55

boat2
false
0
Polygon -1 true false 63 162 90 207 223 207 290 162
Rectangle -6459832 true false 150 32 157 162
Polygon -13345367 true false 150 34 131 49 145 47 147 48 149 49
Polygon -7500403 true true 157 54 175 79 174 96 185 102 178 112 194 124 196 131 190 139 192 146 211 151 216 154 157 154
Polygon -7500403 true true 150 74 146 91 139 99 143 114 141 123 137 126 131 129 132 139 142 136 126 142 119 147 148 147

boat3
false
0
Polygon -1 true false 63 162 90 207 223 207 290 162
Rectangle -6459832 true false 150 32 157 162
Polygon -13345367 true false 150 34 131 49 145 47 147 48 149 49
Polygon -7500403 true true 158 37 172 45 188 59 202 79 217 109 220 130 218 147 204 156 158 156 161 142 170 123 170 102 169 88 165 62
Polygon -7500403 true true 149 66 142 78 139 96 141 111 146 139 148 147 110 147 113 131 118 106 126 71

box
true
0
Polygon -7500403 true true 45 255 255 255 255 45 45 45

butterfly1
true
0
Polygon -16777216 true false 151 76 138 91 138 284 150 296 162 286 162 91
Polygon -7500403 true true 164 106 184 79 205 61 236 48 259 53 279 86 287 119 289 158 278 177 256 182 164 181
Polygon -7500403 true true 136 110 119 82 110 71 85 61 59 48 36 56 17 88 6 115 2 147 15 178 134 178
Polygon -7500403 true true 46 181 28 227 50 255 77 273 112 283 135 274 135 180
Polygon -7500403 true true 165 185 254 184 272 224 255 251 236 267 191 283 164 276
Line -7500403 true 167 47 159 82
Line -7500403 true 136 47 145 81
Circle -7500403 true true 165 45 8
Circle -7500403 true true 134 45 6
Circle -7500403 true true 133 44 7
Circle -7500403 true true 133 43 8

circle
false
0
Circle -7500403 true true 35 35 230

food
true
0
Circle -2674135 true false 120 120 60
Rectangle -10899396 true false 150 105 150 120
Line -10899396 false 150 105 180 75

link
true
0
Line -7500403 true 150 0 150 300

link direction
true
0
Line -7500403 true 150 150 90 180
Line -7500403 true 150 150 210 180

person
false
0
Circle -7500403 true true 155 20 63
Rectangle -7500403 true true 158 79 217 164
Polygon -7500403 true true 158 81 110 129 131 143 158 109 165 110
Polygon -7500403 true true 216 83 267 123 248 143 215 107
Polygon -7500403 true true 167 163 145 234 183 234 183 163
Polygon -7500403 true true 195 163 195 233 227 233 206 159

sheep
false
15
Rectangle -1 true true 90 75 270 225
Circle -1 true true 15 75 150
Rectangle -16777216 true false 81 225 134 286
Rectangle -16777216 true false 180 225 238 285
Circle -16777216 true false 1 88 92

spacecraft
true
0
Polygon -7500403 true true 150 0 180 135 255 255 225 240 150 180 75 240 45 255 120 135

thin-arrow
true
0
Polygon -7500403 true true 150 0 0 150 120 150 120 293 180 293 180 150 300 150

truck-down
false
0
Polygon -7500403 true true 225 30 225 270 120 270 105 210 60 180 45 30 105 60 105 30
Polygon -8630108 true false 195 75 195 120 240 120 240 75
Polygon -8630108 true false 195 225 195 180 240 180 240 225

truck-left
false
0
Polygon -7500403 true true 120 135 225 135 225 210 75 210 75 165 105 165
Polygon -8630108 true false 90 210 105 225 120 210
Polygon -8630108 true false 180 210 195 225 210 210

truck-right
false
0
Polygon -7500403 true true 180 135 75 135 75 210 225 210 225 165 195 165
Polygon -8630108 true false 210 210 195 225 180 210
Polygon -8630108 true false 120 210 105 225 90 210

turtle
true
0
Polygon -7500403 true true 138 75 162 75 165 105 225 105 225 142 195 135 195 187 225 195 225 225 195 217 195 202 105 202 105 217 75 225 75 195 105 187 105 135 75 142 75 105 135 105

wolf
false
0
Rectangle -7500403 true true 15 105 105 165
Rectangle -7500403 true true 45 90 105 105
Polygon -7500403 true true 60 90 83 44 104 90
Polygon -16777216 true false 67 90 82 59 97 89
Rectangle -1 true false 48 93 59 105
Rectangle -16777216 true false 51 96 55 101
Rectangle -16777216 true false 0 121 15 135
Rectangle -16777216 true false 15 136 60 151
Polygon -1 true false 15 136 23 149 31 136
Polygon -1 true false 30 151 37 136 43 151
Rectangle -7500403 true true 105 120 263 195
Rectangle -7500403 true true 108 195 259 201
Rectangle -7500403 true true 114 201 252 210
Rectangle -7500403 true true 120 210 243 214
Rectangle -7500403 true true 115 114 255 120
Rectangle -7500403 true true 128 108 248 114
Rectangle -7500403 true true 150 105 225 108
Rectangle -7500403 true true 132 214 155 270
Rectangle -7500403 true true 110 260 132 270
Rectangle -7500403 true true 210 214 232 270
Rectangle -7500403 true true 189 260 210 270
Line -7500403 true 263 127 281 155
Line -7500403 true 281 155 281 192

wolf-left
false
3
Polygon -6459832 true true 117 97 91 74 66 74 60 85 36 85 38 92 44 97 62 97 81 117 84 134 92 147 109 152 136 144 174 144 174 103 143 103 134 97
Polygon -6459832 true true 87 80 79 55 76 79
Polygon -6459832 true true 81 75 70 58 73 82
Polygon -6459832 true true 99 131 76 152 76 163 96 182 104 182 109 173 102 167 99 173 87 159 104 140
Polygon -6459832 true true 107 138 107 186 98 190 99 196 112 196 115 190
Polygon -6459832 true true 116 140 114 189 105 137
Rectangle -6459832 true true 109 150 114 192
Rectangle -6459832 true true 111 143 116 191
Polygon -6459832 true true 168 106 184 98 205 98 218 115 218 137 186 164 196 176 195 194 178 195 178 183 188 183 169 164 173 144
Polygon -6459832 true true 207 140 200 163 206 175 207 192 193 189 192 177 198 176 185 150
Polygon -6459832 true true 214 134 203 168 192 148
Polygon -6459832 true true 204 151 203 176 193 148
Polygon -6459832 true true 207 103 221 98 236 101 243 115 243 128 256 142 239 143 233 133 225 115 214 114

wolf-right
false
3
Polygon -6459832 true true 170 127 200 93 231 93 237 103 262 103 261 113 253 119 231 119 215 143 213 160 208 173 189 187 169 190 154 190 126 180 106 171 72 171 73 126 122 126 144 123 159 123
Polygon -6459832 true true 201 99 214 69 215 99
Polygon -6459832 true true 207 98 223 71 220 101
Polygon -6459832 true true 184 172 189 234 203 238 203 246 187 247 180 239 171 180
Polygon -6459832 true true 197 174 204 220 218 224 219 234 201 232 195 225 179 179
Polygon -6459832 true true 78 167 95 187 95 208 79 220 92 234 98 235 100 249 81 246 76 241 61 212 65 195 52 170 45 150 44 128 55 121 69 121 81 135
Polygon -6459832 true true 48 143 58 141
Polygon -6459832 true true 46 136 68 137
Polygon -6459832 true true 45 129 35 142 37 159 53 192 47 210 62 238 80 237
Line -16777216 false 74 237 59 213
Line -16777216 false 59 213 59 212
Line -16777216 false 58 211 67 192
Polygon -6459832 true true 38 138 66 149
Polygon -6459832 true true 46 128 33 120 21 118 11 123 3 138 5 160 13 178 9 192 0 199 20 196 25 179 24 161 25 148 45 140
Polygon -6459832 true true 67 122 96 126 63 144
@#$#@#$#@
NetLogo 6.0
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
<experiments>
  <experiment name="Travel Distance to Supermarkets" repetitions="5" runMetricsEveryStep="true">
    <setup>setup
random-seed behaviorspace-run-number</setup>
    <go>go</go>
    <exitCondition>ticks &gt; 120</exitCondition>
    <metric>median [ min [distance myself] of supermarkets ] of rich</metric>
    <metric>median [ min [distance myself] of supermarkets ] of poor</metric>
    <steppedValueSet variable="number-of-tests" first="25" step="10" last="55"/>
    <steppedValueSet variable="poor-health-priority" first="-1" step="0.1" last="1"/>
    <steppedValueSet variable="max-jobs" first="1" step="2" last="10"/>
    <steppedValueSet variable="rich-per-step" first="1" step="5" last="10"/>
    <steppedValueSet variable="max-supermarkets" first="1" step="2" last="10"/>
    <steppedValueSet variable="residents-per-job" first="25" step="25" last="100"/>
    <steppedValueSet variable="death-rate" first="1" step="1" last="4"/>
    <steppedValueSet variable="poor-per-step" first="1" step="2" last="10"/>
    <steppedValueSet variable="poor-price-priority" first="0" step="0.1" last="1"/>
    <steppedValueSet variable="rich-quality-priority" first="0" step="0.1" last="1"/>
  </experiment>
  <experiment name="Count rich/poor in desert" repetitions="10" runMetricsEveryStep="true">
    <setup>setup</setup>
    <go>go</go>
    <metric>count rich in-radius 10 of patches with [any? supermarkets]</metric>
    <metric>count poor in-radius 10 of patches with [any? supermarkets]</metric>
    <enumeratedValueSet variable="n_supermarkets">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="number-of-tests">
      <value value="100"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="poor-health-priority">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="max-jobs">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="rich-per-step">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="max-supermarkets">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="residents-per-job">
      <value value="100"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="death-rate">
      <value value="4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="poor-per-step">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="poor-price-priority">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="rich-quality-priority">
      <value value="1"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="Health" repetitions="100" runMetricsEveryStep="true">
    <setup>setup</setup>
    <go>go</go>
    <metric>median [health] of poor</metric>
    <metric>median [health] of rich</metric>
    <enumeratedValueSet variable="number-of-tests">
      <value value="30"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="poor-health-priority">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="max-jobs">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="rich-per-step">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="rich-health-priority">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="max-supermarkets">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="residents-per-job">
      <value value="100"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="poor-per-step">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="poor-price-priority">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="rich-quality-priority">
      <value value="0"/>
    </enumeratedValueSet>
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
1
@#$#@#$#@
