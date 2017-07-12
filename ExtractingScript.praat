directory$ = "/Users/phonetics/Desktop/Ian/Laterals Project/Lateral Analysis/Second Recording/"
output$ = directory$
numsections = 5


table = Create Table with column names: "table", 0, "word section time F1 F2 F3"

#Get list of TextGrids
strings = Create Strings as file list: "list", directory$+"*.TextGrid"

numberOfFiles = Get number of strings
for a to numberOfFiles
    selectObject: strings
    fileName$ = Get string: a

    #Substitutions
    base$ = replace$(fileName$, ".TextGrid", "", 0)

    text_grid = Read from file: directory$+fileName$
    wav_name$ = replace$(base$, "_", " ", 0)
    if fileReadable(directory$+wav_name$+".wav")
	printline Reading 'directory$''wav_name$'.wav...
	sound_file = Read from file: directory$+wav_name$+".wav"
	selectObject: text_grid
	intervals = Get number of intervals: 2
        for b to intervals
	    ##printline 'b'
            selectObject: text_grid
	    label$ = Get label of interval: 2, b
            if label$ <> ""
		start = Get starting point: 2, b
                end = Get end point: 2, b
                duration = end - start
                sectionlength = duration / numsections
                selectObject: sound_file
                part = Extract part: start, end, "rectangular", 1.0, "no"
                folders = Create Strings as directory list: "folders", directory$+"*"          
                folderQuery = To WordList
                folder_present = Has word... label$
                selectObject: folders
                plusObject: folderQuery
                Remove
                if (folder_present) == 0
                    createDirectory(label$)
                endif

                for c to numsections
			selectObject: part
                      extract  = Extract part: (c-1)*sectionlength, c*sectionlength, "rectangular", 1.0, "no"
                      resample = Resample: 16000, 60
                      formant = To Formant (burg): 0.0, 5, 4400, 0.02, 50
                      time = (0.5)*sectionlength
                      selectObject: table
                      Append row
                      current_row = Get number of rows
                      Set string value: current_row, "word", label$
                      Set numeric value: current_row, "section", c
                      Set numeric value: current_row, "time", time
                      for d to 3
                          selectObject: formant
                          value = Get value at time: d, time, "Hertz", "Linear"
                          selectObject: table
                          Set numeric value: current_row, "F'd'", value
                      endfor 
                      selectObject:  extract
                      plusObject: resample
                      plusObject: formant
                      Remove
                endfor
	         selectObject: part
                Remove
            endif
        endfor
    else
        printline 'directory$''wav_name$'+".wav" not found
    endif
    selectObject: text_grid
    plusObject: sound_file
    Remove
endfor

selectObject: table
Save as comma-separated file: output$+"formant-table.csv"
selectObject: strings
plusObject: table
Remove
printline "Finished"