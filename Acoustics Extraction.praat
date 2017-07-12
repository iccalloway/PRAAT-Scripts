##Variables
outFile$ = "output.txt"
dirName$ = "./"
maxFormant = 5000
points = 4

# creates an output file with the specified name and adds headings 
# NB: if the named output file exists, it will be overwritten

outLine$ = "participant" + tab$ + "word" + tab$ + "section" + tab$ + "f0" + tab$ + "f1" + tab$ + "f2" + tab$ + "f3" + tab$ + "duration" + newline$
outLine$ > 'dirName$''outFile$'

Create Strings as file list... fileList 'dirName$'*.TextGrid
nFiles = Get number of strings

for i to nFiles
	# Read in sound file, textgrid, and calculate formant object
	select Strings fileList
	fileName$ = Get string... i
	Read from file... 'dirName$''fileName$'
	name$ = selected$("TextGrid")
	Read from file... 'dirName$''name$'.wav

	# For each labeled interval (vowel), get measurements
	select TextGrid 'name$'
	nIntervals = Get number of intervals... 1
	for j to nIntervals
		select TextGrid 'name$'
		segment$ = Get label of interval... 1 'j'
		if length(segment$) > 0
			# retrieve/calculate time values (duration, midpoint)
			segBeg = Get starting point... 1 'j'
			segEnd = Get end point... 1 'j'
			segDur = segEnd - segBeg
			segMed = (1/2) * (segBeg + segEnd)
			select Sound 'name$'
			Extract part... 'segBeg' 'segEnd' rectangular 1.0 yes
			Rename... extract
			To Formant (burg)... 0.01 5 'maxFormant' 0.025 50
			select Sound extract
			To Pitch (cc)... 0.0 60 15 no 0.03 0.45 0.01 0.35 0.14 600

			for k to points
				timepoint = segBeg + (k/(points+1))*segDur
				# get formant values
				select Formant extract
				f1 = Get value at time... 1 'timepoint' Hertz Linear
				f2 = Get value at time... 2 'timepoint' Hertz Linear
				f3 = Get value at time... 3 'timepoint' Hertz Linear

				# get pitch values
				select Pitch extract
				f0 = Get value at time... 'timepoint' Hertz Linear

				outLine$ = name$ + tab$ + segment$ + tab$ + "'k'" + tab$ + "'f0:1'" + tab$ + "'f1:1'" + tab$ + "'f2:1'" + tab$ + "'f3:1'" + tab$ + "'segDur:4'" + newline$
				outLine$ >> 'dirName$''outFile$'
			endfor
			select Sound extract
			plus Formant extract
			plus Pitch extract
			Remove
		endif
	endfor

	# clean up
	select TextGrid 'name$'
	plus Sound 'name$'
	Remove
endfor

# clean up
select Strings fileList
Remove