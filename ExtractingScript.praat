form Parameters
	sentence Extract_Folder ./
	sentence Save_To ./
	natural Interval 1
endform

printline Extracting from 'extract_Folder$'

createDirectory: save_To$

#Get list of TextGrids
strings = Create Strings as file list: "list", extract_Folder$+"*.TextGrid"

numberOfFiles = Get number of strings



for a to numberOfFiles
    selectObject: strings
    fileName$ = Get string: a

    #Substitutions
    base$ = replace$(fileName$, ".TextGrid", "", 0)
    if fileReadable(extract_Folder$+base$+".wav")
	text_grid = Read from file: extract_Folder$+fileName$

	printline Reading 'extract_Folder$''base$'.wav...
	sound_file = Read from file: extract_Folder$+base$+".wav"

	selectObject: text_grid
	intervals = Get number of intervals: interval
        for b to intervals
            selectObject: text_grid
	    label$ = Get label of interval: interval, b
            if label$ <> ""
		start = Get starting point: interval, b
		end = Get end point: interval, b
		selectObject: sound_file
		snippet = Extract part... start end rectangular 1.0 no
		Save as WAV file... 'save_To$''label$'-'base$'-'b'.wav
		Remove
            endif
        endfor
    else
        printline 'extract_Folder$''wav_name$'+".wav" not found
    endif
    selectObject: text_grid
    plusObject: sound_file
    Remove
endfor

selectObject: strings
Remove

printline "Finished!"
