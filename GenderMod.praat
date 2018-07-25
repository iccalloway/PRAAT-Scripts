##GenderMod.praat - Helps streamline the process for altering F0 and aVTL (acoustic cues to gender)
##=================

form Modification Settings
	choice Style: 2
		button Feminize
		button Masculinize
	natural Steps 5
	positive End_F0 150
	positive Formant_Scaling_Factor 1.1
	sentence Output_Folder ~/
endform

output$ = "~/"

if style$ = "Feminize"
	dir$ = "f"
	fr = formant_Scaling_Factor
else
	dir$ = "m"
	fr = 1/formant_Scaling_Factor
endif

sounds = numberOfSelected ("Sound")
for a to sounds
	sound [a] = selected ("Sound", a)
endfor

for a to sounds
	selectObject: sound [a]
	name$ = selected$ ("Sound")
	pitch = To Pitch... 0.0 75.0 600.0
	pt = Down to PitchTier
	f0 = Get mean (points)... 0.0 0.0
	for b to steps
		nr = 1 + (fr-1)*(b-1)/(steps-1)
		nf0 = f0 + (end_F0 - f0)*(b-1)/(steps-1)
		selectObject: sound[a]
		mod = Change gender... 75.0 600.0 nr nf0 1.0 1.0
		Save as WAV file... 'output_Folder$''name$'-'dir$'-'b'.wav
		Remove
	endfor
	selectObject: "Pitch 'name$'"
	plusObject: "PitchTier 'name$'"
	Remove
endfor
printline Finished!
