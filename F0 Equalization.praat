#Variables

pause Select two sounds to equalize F0 for

final_pitch = 155

sound1$ = selected$("Sound",1)
sound2$ = selected$("Sound",2)

##Extract F0 Contours for Tokens
select Sound 'sound1$'
To Manipulation... 0.01 75 300
Extract pitch tier
Rename... 'sound1$'_original_pitch
Copy... one_modified_pitch
one_pitch = Get mean (curve)... 0.0 0.0

select Sound 'sound2$'
To Manipulation... 0.01 75 300
Extract pitch tier
Rename... 'sound2$'_original_pitch
Copy... two_modified_pitch
two_pitch = Get mean (curve)... 0.0 0.0

##Calculate Mean F0 for Voices
#gmean_pitch = sqrt('one_pitch'*'two_pitch')

##Set F0 of New Contours to Desired Value
#final_pitch = gmean_pitch
select PitchTier one_modified_pitch
plus PitchTier two_modified_pitch
Formula... final_pitch

##Apply New PitchTiers to Manipulation File and Resynthesize New Sound File
select PitchTier one_modified_pitch
plus Manipulation 'sound1$'
Replace pitch tier
minus PitchTier one_modified_pitch
Get resynthesis (overlap-add)
Rename... 'sound1$'_equal_f0


select PitchTier two_modified_pitch
plus Manipulation 'sound2$'
Replace pitch tier
minus PitchTier two_modified_pitch
Get resynthesis (overlap-add)
Rename... 'sound2$'_equal_f0


select Manipulation 'sound1$'
plus PitchTier one_modified_pitch
plus Manipulation 'sound2$'
plus PitchTier two_modified_pitch
Remove
