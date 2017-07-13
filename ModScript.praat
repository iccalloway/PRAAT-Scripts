directory$ = "./"

strings = Create Strings as file list: "list", directory$+"*.wav"
numberOfFiles = Get number of strings
for a to numberOfFiles
    selectObject: strings
    fileName$ = Get string: a
	silence = Create Sound from formula... silence 1 0.0 0.05 44100 0 
	sound_file = Read from file: directory$+fileName$

	#Modify intensity
	selectObject: sound_file
	Scale intensity... 70.0
	#Save as WAV file... 'directory$'IntensityModified-'fileName$'

	#Append silences
	selectObject: silence
	end = Copy... end
	selectObject: silence
	plusObject: sound_file
	plusObject: end
	Concatenate
	Save as WAV file... 'directory$'Final-'fileName$'
    selectObject: sound_file
    plusObject: end
    plusObject: silence
    plusObject: "Sound chain"
    Remove
endfor
selectObject: strings
Remove
printline "Finished"