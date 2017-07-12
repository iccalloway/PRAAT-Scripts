pause select two pitch tiers

original_f0 = 140Hz  

tier1$ = selected$("PitchTier",1)
tier2$ = selected$("PitchTier",2)

select PitchTier 'tier1$'
points1 = Get number of points

select PitchTier 'tier2$'
points2 = Get number of points

points = min(points1, points2)

new_tier = Create PitchTier... blended 0.0 2.0
while a from 1 to points
    pitch1 = 
    pitch2 = 
    Add point... 
endfor

