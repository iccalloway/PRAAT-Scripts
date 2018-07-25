##long-concat.praat - Iteratively pastes together groups of sound objects
##=========================
##For each unique combination of sound objects according to their respective groups and the groups' order
##this script creates one sound file composed of those sound objects concatenated together.

continue = 1
count = 0

form Where to Save?
	sentence Save_Location ./
endform

while continue = 1
	beginPause: "Select Group #'count' Sounds"
	clicked = endPause: "Additional Group", "Concatenate", 0
	printline 'clicked'

	count = count + 1
	max'count' = numberOfSelected ("Sound")
	for a to max'count'
		sound'count' [a] = selected ("Sound", a)
	endfor

	if clicked = 2
		continue = 0
	else
		continue = 1
	endif
endwhile


if count > 0
	##Initialize array with ones
	for a to count
		iterator'a'= 1
	endfor

	n=count
	while (iterator1 <= max1) and (n > 0)
		n=count
		##printline 'iterator1' 'iterator2' 'iterator3' 'iterator4' 'iterator5'
	
		##Select relevant sound objects
		selectObject: sound1 [iterator1]
		name1$ = selected$ ("Sound")
		Copy... new1
		for a from 2 to count
			selectObject:sound'a' [iterator'a']
			name'a'$ = selected$ ("Sound")
			Copy... new'a'
		endfor
		
		selectObject: "Sound new1"
		full_name$ = name1$
		for a from 2 to count
			plusObject: "Sound new'a'"
			full_name$ = full_name$ + "-"+ name'a'$
		endfor
		
		##Concatenate and Save
		Concatenate
		
		Save as WAV file... 'save_Location$''full_name$'.wav

		selectObject: "Sound new1"
		for a from 2 to count
			plusObject: "Sound new'a'"
		endfor
		plusObject: "Sound chain"
		Remove


		##Increment array
		iterator'n' = iterator'n' + 1

		##Carry ones
		while (iterator'n' > max'n') and (n>1)
			iterator'n' = 1
			n = n -1 
			if (n > 0)
			iterator'n' = iterator'n' + 1
			endif
		endwhile
	endwhile
endif
