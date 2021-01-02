%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% (c) copyright 2021 Sepideh Shafiei (sepideh.shafiee@gmail.com), all rights reserved
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function visualizeData(PracticeDataName,AllTheoriesGushe,NoteNames,m)

variables; % the note name variables that are in the file variables.m
histoArray=m.Histo; %table2array(histoTable);
practiceChords=m.Segrange;
X=practiceChords(1,:);
pChordNum=size(X(X~=0),2);

if pChordNum>8
    pChordNum=8;
end

NoteNames=["do","doS","ReB","ReK","Re", "ReS","MiB", "MiK", "Mi ", "miS", "fa ", "faS","fa #", "SolK", "Sol",...
    "SolS", "LaB", "LaK", "La", "LaS", "SiB", "SiK", "Si", "SiS","do2","doS2","ReB2","ReK2","Re2", "ReS2","MiB2", "MiK2", "Mi2 ", "miS2", "fa2 ", "faS2","SolB2", "SolK2", "Sol2",...
    "SolS2", "LaB2", "LaK2", "La2", "LaS2", "SiB2", "SiK2", "Si2","SiS2", ...
    "do3","doS3","ReB3","ReK3","Re3", "ReS3","MiB3", "MiK3", "Mi3 ", "miS3", "fa3 ", "faS3","SolB3", "SolK3", "Sol3",...
    "SolS3", "LaB3", "LaK3", "La3", "LaS3", "SiB3", "SiK3", "Si3","SiS3"]';

totalColors= 7;
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

figure;   % doing multiple maqams/Gusheh in this loop
segmntAx2=subplot(5,1,1); %sentence segments subplot
maxRange=68;
SColorMatrix=colorGray*ones(8,maxRange+1); %fill the full graph with gray elements
offset=0;


for chord=1:pChordNum
    indx=1;
    while ( practiceChords(indx, chord) ~=0 )
        loc = practiceChords(indx,  chord) -24*4-13;
        if loc >0
            SColorMatrix(chord, loc) = mod(chord,3) +2; % rotate through 3 colors
        else
            error("note in segment too low: practiceChords(%d,  %d)=%d",...
                indx,  chord, practiceChords(indx,  chord));
        end
        indx = indx + 1;
    end
end

Sh=imagesc(SColorMatrix(1:end, offset+1:maxRange+offset+1), [0 7]);
colormap ( [1,1,1;   .9,.2,.1;   0,1,0;  0,.6,1;  1,.4,0;   .99,.99,.99;   .1,1,.9; 0.9,0.9,0]);
ax = gca;
ax.TitleFontSizeMultiplier = 1.5;

set(segmntAx2, 'XTick', 1:maxRange+offset+1, 'XTickLabel', NoteNames(offset+1:maxRange+offset+1), 'XTickLabelRotation',45,'fontsize', 7);
title("sentence segments", 'interpreter', 'none');
[rows,cols] = size(SColorMatrix);
for i = 1:rows
    for j = offset+1:maxRange+offset+1
        if SColorMatrix(i,j) == colorGray
            textHandles(j,i) = text(j-offset,i,"-", 'horizontalAlignment','center');
        end
    end
end

axis1= subplot(5,1,2);
histoArray(138:180)=0;
bar (histoArray(110:110+maxRange));
title("MIDI histogram", 'interpreter', 'none'); %contains the notes with the total duration more than the 2% of the duration of the piece
pos = get(gca, 'Position');
pos(1) = 0.121;
pos(3) = 0.793; %width
set(gca, 'Position', pos)
ax = gca;
ax.TitleFontSizeMultiplier = 1.5;


for i=1:size(AllTheoriesGushe,2)
    TheoryName=AllTheoriesGushe(1,i);
    maqamName=AllTheoriesGushe(2,i);
    maqamNotes =AllTheoriesGushe(5:end, i);
    
    subplot(5,1,i+2); %histogram + theory
    [chordColor, chordLevel, noteLabels,maqamInfo, mainNotes, maxRange1,  offset] = ...
        theoryTableSetup(NoteNames, NoteNames, maqamNotes  );
    
    noteLabels=  noteLabels';
    chordLevel = chordLevel';
    chordColor=  chordColor';
    ColorMatrix=colorGray*ones(totalLevels,size(NoteNames,1));  %fill the full graph with gray elements
    tableIndex =0;
    
    while ( chordLevel(tableIndex+1) ~= -10)
        tableIndex = tableIndex +1;
    end
    for i = 1: tableIndex   % set up z=f(x,y) table for imagesc
        ColorMatrix(chordLevel(i)+1, noteLabels(i)) = chordColor(i); %adjust non gray colors
    end
    
    h=imagesc(ColorMatrix(1:end, offset+1:maxRange+offset+1), [0 8]);
    titleStr= sprintf("%s----%s", TheoryName,maqamName);
    title(titleStr, 'interpreter', 'none');  % two line title
    ax = gca;
    ax.TitleFontSizeMultiplier = 1.5;
    set(gca, 'XTick', 1:maxRange+offset+1, 'XTickLabel', NoteNames(offset+1:maxRange+offset+1), 'XTickLabelRotation',45,'fontsize', 7);
    set(gca, 'YTick', 1:4, 'YTickLabel', ["Main Notes","Third Range", "Second Range","First Range","A"], 'YTickLabelRotation',45);
    set(axis1, 'XTick', 1:maxRange+offset+1, 'XTickLabel', NoteNames(offset+1:maxRange+offset+1), 'XTickLabelRotation',45,'fontsize', 7);
    
    hold on;
    [rows,cols] = size(ColorMatrix);
    for i = 1:rows
        for j = offset+1:maxRange+offset+1
            if (i ==totalLevels) &&( maqamInfo(j)~= "" )
                textHandles(j,i) = text(j-offset,i,maqamInfo(j), 'horizontalAlignment','center');
            elseif  (i ==Level4) &&( mainNotes(j)~= "" )
                textHandles(j,i) = text(j-offset,i,"M", 'horizontalAlignment','center');
            elseif ColorMatrix(i,j) == colorGray
                textHandles(j,i) = text(j-offset,i,"-", 'horizontalAlignment','center');
            else
                textHandles(j,i) = text(j-offset,i,num2str(ColorMatrix(i,j)), 'horizontalAlignment','center');
            end
        end
    end
    
    % draw 1x1 boxes around "S", "I", "F", ...
    for j = 1:cols
        if ( maqamInfo(j)~= "" )
            h1 = rectangle('position',[j-offset-.5 totalLevels-.5 1 1]);
            set(h1,'EdgeColor',[1 0 0],'linewidth',1);
        end
    end
    
    %Draw a 1x1 box around each main note and then, a big box around all Main notes
    firstMainNotes =cols;
    lastMainNotes = 0;
    for j = 1:cols
        if ( mainNotes(j)~= "" )
            h1 = rectangle('position',[j-offset-.5 Level4-.5 1 1]);
            set(h1,'EdgeColor',[1 1 0],'linewidth',1);
            if (j< firstMainNotes)
                firstMainNotes =j;
            end
            if ( j> lastMainNotes)
                lastMainNotes =j;
            end
        end
    end
    if (lastMainNotes == 0)  || (firstMainNotes ==cols)
        error("no main notes");
    end
    
    offset=0;
    h1 = rectangle('position',[firstMainNotes-offset-.5 Level4-.5  (lastMainNotes-firstMainNotes)+1 1]);
    set(h1,'EdgeColor',[.8 .4 .8],'linewidth',1);
    set(gcf,'position',[500,500,700,380]);
    orient(gcf,'landscape');
    
end
