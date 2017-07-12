# # ## ### ##### ########  #############  ##################### 
# Praat Script
# gradually blend two sounds
#
# Matthew Winn
# August 2014

# This is a blending script that use the built-in blending function .
# The blending function will blend two sounds by overlaying one over the other gradual
# by given number of steps.
# The gradual blending is achieved by controlling the intensity of the two sounds that 
# will be blended together. If we want to blend two sounds A and B in nine steps, the script will 
# do that by overlaying sound A over B and gradually raising the intensity of A and attenuating 
# intensity of B in Every step. So if we are making 7-continuum of A to B, step 1 will be mostly A.
# and step B will be mostly B.
##################################
##################### 
############# 
######## 
#####
###
##
#
#
clearinfo

numberOfSteps = 5

pause select two sounds to blend

sound1$ = selected$("Sound",1)
sound2$ = selected$("Sound",2)

# call the blending function with the specified number of steps,
# name the files using a combination of both sound names (the last argument) 

call gradualBlend2Sounds 'sound1$' 'sound2$' numberOfSteps 'sound1$'_'sound2$'_

procedure gradualBlend2Sounds .sound1$ .sound2$ .steps .namePrefix$

for .thisStep from 1 to .steps

.sound2Multiplier = (.thisStep-1)/(.steps-1)
.sound1Multiplier = 1-.sound2Multiplier

print Step '.thisStep''tab$''.sound1Multiplier:3''tab$''.sound2Multiplier:3''newline$'

select Sound '.sound1$'
Copy... '.namePrefix$''.thisStep'
Multiply... .sound1Multiplier
Formula... self [col] + (.sound2Multiplier*Sound_'.sound2$' [col])

endfor