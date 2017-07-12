##Select sound object and interval bounds
pause Select Sound Object 
sound$ = selected$("Sound",1)

View & Edit
editor: "Sound " + sound$
	pause Choose anchoring interval for intensity scaling  
	segBeg = Get start of selection
	segEnd = Get end of selection
	Close
endeditor

##Calculate intensity for interval and overall sound object
select Sound 'sound$'
extractedSound = Extract part... 'segBeg' 'segEnd' rectangular 1.0 yes
extractedintensity = Get intensity (dB)
if extractedintensity == undefined
	printline Interval intensity is not defined
	exit
endif


selectObject: extractedSound
Remove

##Calculate scaling factor and modify new object
select Sound 'sound$'
overallintensity = Get intensity (dB)

##User input on desired method of scaling
beginPause: "Get New Intensity"
	comment: "Intensity of the selected interval is "+"'extractedintensity'"+" dB."
	comment: "Please choose a new intensity for this interval."
	real: "Intensity", 70.0
	choice: "Scope", 3
		option: "Modify interval intensity only"
		option: "Scale entire Sound intensity"
		option: "Scale intensity over custom region"
endPause: "Continue", 1

select Sound 'sound$'
end = Get end time

if scope == 1
	intBeg = segBeg
	intEnd = segEnd
elsif scope == 2
	intBeg = 0.0
	intEnd = end
elsif scope == 3
	grid = To TextGrid... "interval" ""
	if segBeg > 0
		Insert boundary... 1 'segBeg'
	endif

	if segEnd < end
		if segEnd != segBeg
			Insert boundary... 1 'segEnd'
		endif
	endif

	if segBeg != segEnd
		interval = Get interval at time... 1 (segBeg+segEnd)/2
		Set interval text... 1 interval Original Interval
	endif
	
	select Sound 'sound$'
	plusObject: grid

	View & Edit
	editor: grid
		Select... 'segBeg' 'segEnd'
		pause Choose region of application.  Bounds must span original interval.
		intBeg = Get start of selection
		intEnd = Get end of selection
		Close
	endeditor
	selectObject: grid
	Remove
endif
	
if intBeg <= segBeg
	if intEnd >= segEnd
		select Sound 'sound$'
		part1 = Extract part... 0.0 'intBeg' rectangular 1.0 yes
		select Sound 'sound$'
		part2 = Extract part... 'intBeg' 'intEnd' rectangular 1.0 yes
		intIntensity = Get intensity (dB)
		Scale intensity... intensity+intIntensity-extractedintensity
		select Sound 'sound$'
		part3 = Extract part... 'intEnd' 'end' rectangular 1.0 yes
		selectObject: part2
		if 'intEnd' < end
			plusObject: part3
		endif
		if 'intBeg' > 0
			plusObject: part1
		endif
		Concatenate
		Rename... 'sound$'-intensityscaled
		selectObject: part1
		plusObject: part2
		plusObject: part3
		Remove
	else
		printline Region of application must span original interval
		exit
	endif
else
	printline Region of application must span original interval
	exit
endif


printline Mean intensity of interval from 'segBeg' to 'segEnd' set to 'intensity' dB.
