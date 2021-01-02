%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% (c) copyright 2021 Sepideh Shafiei (sepideh.shafiee@gmail.com), all rights reserved
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [chordColor, chordLevel, noteLabels,maqamInfo, mainNotes, maxRange,  offset] = ...
                 theoryTableSetup(All48Notes, theoryNotes, maqamNotes )

totalLevels=6;
colorW=0;
colorR=1;
colorG=2;
colorB=3;
colorY=4;
colorGray=5;

Level0=totalLevels -1;  
Level1=totalLevels -2;
Level2=totalLevels -3;
Level3=totalLevels -4;
Level4=totalLevels -5;
Level5=totalLevels -6;

maxRange = 0;
firstMainNotes=0;
lastMainNotes=0;

for i =1:size(All48Notes)
    chordColor(i) = colorGray; %gray
    chordLevel(i) = -10;
    noteLabels(i) = 1; % Level0;
    maqamInfo(i) = "";
    mainNotes(i)="";
    if ( i >= size(theoryNotes, 2))
        maxRange= size(theoryNotes, 2)*2;
    elseif ( length(theoryNotes(i))==0   )  && (i > 10) && (maxRange == 0)
        maxRange= i;
        maxRange= size(theoryNotes, 2)*2; 
    end
end

%find the starting point of the notes used in each dastgah
for offset =1:size(All48Notes)
    if ( contains(All48Notes(offset,:),  theoryNotes(1) ))
        break
    end
end

offset = offset -1 ; % offset of notes in theoretical table vs. the constant table in this program
tableIndex=1; % notes we have for this maqam.
firstStart=0;
firstEnd=0;
secondStart=0;
secondEnd=0;
thirdStart=0;
thirdEnd=0;
offset=0;

for i =1:size(maqamNotes,1)  
    
    if ( contains(maqamNotes(i,:), '0' ))
        chordColor(tableIndex) = colorW;
        chordLevel(tableIndex) = Level0;
        noteLabels(tableIndex) = i+offset;
        tableIndex = tableIndex + 1;
    end
   
    if ( contains(maqamNotes(i,:), '1' ))
        chordColor(tableIndex) = colorR;
        chordLevel(tableIndex) = Level1;
        noteLabels(tableIndex) = i+offset;
        tableIndex = tableIndex + 1;
        
        if (firstStart==0)  || (firstStart > i)
            firstStart = i;
        end
        
        if firstEnd < i
            firstEnd =i;
        end
        
    end

    if ( contains(maqamNotes(i,:), '2' ))
        chordColor(tableIndex) = colorG;
        chordLevel(tableIndex) = Level2;
        noteLabels(tableIndex) = i+offset;
        tableIndex = tableIndex + 1;
        if (secondStart==0)  || (secondStart > i)
            secondStart = i;
        end
        if secondEnd < i
            secondEnd =i;
        end
    end

    if ( contains(maqamNotes(i,:), '3' ))
        chordColor(tableIndex) = colorB;
        chordLevel(tableIndex) = Level3;
        noteLabels(tableIndex) = i+offset;
        tableIndex = tableIndex + 1;
        if (thirdStart==0)  || (thirdStart > i)
            thirdStart = i;
        end
        if firstEnd < i
           thirdEnd =i;
        end
    end
    
    
     if ( contains(maqamNotes(i,:), '4' ))
        chordColor(tableIndex) = colorY;
        chordLevel(tableIndex) = Level4;
        noteLabels(tableIndex) = i+offset;
        tableIndex = tableIndex + 1;
        if (thirdStart==0)  || (thirdStart > i)
            thirdStart = i;
        end
        if firstEnd < i
           thirdEnd =i;
        end
     end
    
 
    if (( contains(maqamNotes(i,:), 'sh' )) || ( contains(maqamNotes(i,:), 'Sh' )))
        maqamInfo(i+offset) = strcat(maqamInfo(i+offset),"S");
    end
    
    if ( contains(maqamNotes(i,:), 'I' ))
        maqamInfo(i+offset) = strcat(maqamInfo(i+offset),"I");
        
    end
   
    if ( contains(maqamNotes(i,:), 'f' ))
        if i+offset<length(maqamInfo) 
            maqamInfo(i+offset) = strcat(maqamInfo(i+offset),"F");
        end
    end

    if ( contains(maqamNotes(i,:), 'm' ))

        mainNotes(i+offset) = strcat(mainNotes(i+offset),"M");
        if firstMainNotes == 0
            firstMainNotes= i+offset;
        end
        lastMainNotes= i+offset;
    end
    
    if ( contains(maqamNotes(i,:), 'v' ))
        maqamInfo(i+offset) = strcat(maqamInfo(i+offset),"V");
    end
    
end
end