%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% (c) copyright 2021 Sepideh Shafiei (sepideh.shafiee@gmail.com), all rights reserved
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This code compares and visualizes current theories of Persian/Iranian classical music with each other and
% the theories extracted from practice --

clc;
clear variables;
cd /Users/sepid/Desktop/TheoryPracticeComparison/DataTheoreticalTable;
listPracticeFiles=ls('./*.mat');
listTheoreticalFiles=ls('./*.xlsx');
currentPracFileNameStr=split(listPracticeFiles, './');
numFilesPractice=length(currentPracFileNameStr);
currentTheoreticalName=split(listTheoreticalFiles, './');
numFilesTheory=length(currentTheoreticalName);

for practiceFileNumber = 1: numFilesPractice
    AllTheoriesGushe=strings(68,1); %All Theories for one gushe
    if (length(char(currentPracFileNameStr(practiceFileNumber)))<2)
        continue
    end
    pStrLen=length(char(currentPracFileNameStr(practiceFileNumber)));
    PracticeDataName=extractBetween(currentPracFileNameStr(practiceFileNumber),1,pStrLen-1);
    [matchGushe,noMatch] = regexp(PracticeDataName,'_G\d*_','match','split');
    
    if (size(matchGushe,2)==0) % no match
        continue;
    end
    
    m=load(string(PracticeDataName));
    
    for theoryFileNumber = 1: numFilesTheory
        if ((length(char(currentTheoreticalName(theoryFileNumber)))<2) ||...
                ( contains(char(currentTheoreticalName(theoryFileNumber)), '~$' ))) %tmp open files
            continue
        end
        
        strLenTheory=length(char(currentTheoreticalName(theoryFileNumber)));
        TheoryDataName(theoryFileNumber)=extractBetween(currentTheoreticalName(theoryFileNumber),1,strLenTheory-1);
        TheoreticalTable{theoryFileNumber}= readmatrix(string(TheoryDataName(theoryFileNumber)),'OutputType','string','Range','A1:N54', 'DataRange', 'A1');
        TheoreticalTable{theoryFileNumber};
        
        for col=4:size(TheoreticalTable{theoryFileNumber},2) %gushe names start from column 4
            strTheory=TheoreticalTable{theoryFileNumber}(2,col);
            [match2,noMatch2] = regexp(string(strTheory),string(matchGushe),'match','split');
            
            if (size(match2,1)==0)
                continue
            end
            
            T=AllTheoriesGushe;
            M=strlength(T);
            M(isnan(M))=0;
            
            TheoreticalTable{theoryFileNumber}(1,col)=string(TheoryDataName(theoryFileNumber));
            if sum(M)>1
                AllTheoriesGushe=[AllTheoriesGushe,TheoreticalTable{theoryFileNumber}(1:68,col)];
            else
                AllTheoriesGushe(:,1)=TheoreticalTable{theoryFileNumber}(1:68,col);
            end
            
            TetrachordTheory1=zeros(1,4);
            TetrachordTheory2=zeros(1,4);
            TetrachordTheory3=zeros(1,4);
            MainRangeTheory=zeros(1,10);
            shahedTheory=zeros(1,3);
            istTheory=zeros(1,3);
            variableTheory=zeros(1,3);
            secondaryNotesTheory=zeros(1,4);
            
            tet1Index=1;
            tet2Index=1;
            tet3Index=1;
            rangeIndex=1;
            shahedIndex=1;
            istIndex=1;
            variableIndex=1;
            secondaryNotesIndex=1;
            
            for notes=5:size(TheoreticalTable,1)
                
                if (~isempty(strfind(TheoreticalTable(notes,col), '1')))
                    TetrachordTheory1(1,tet1Index)=str2num(TheoreticalTable(notes,1));
                    tet1Index=tet1Index+1;
                end
                
                if (~isempty(strfind(TheoreticalTable(notes,col), '2')))
                    TetrachordTheory2(1,tet2Index)=str2num(TheoreticalTable(notes,1));
                    tet2Index=tet2Index+1;
                end
                
                if (~isempty(strfind(TheoreticalTable(notes,col), '3')))
                    TetrachordTheory3(1,tet3Index)=str2num(TheoreticalTable(notes,1));
                    tet3Index=tet3Index+1;
                end
                
                
                if (~isempty(strfind(TheoreticalTable(notes,col), 'm')))
                    MainRangeTheory(1,rangeIndex)=str2num(TheoreticalTable(notes,1));
                    rangeIndex=rangeIndex+1;
                end
                
                if (~isempty(strfind(TheoreticalTable(notes,col), 'sh')))
                    shahedTheory(1,shahedIndex)=str2num(TheoreticalTable(notes,1));
                    shahedIndex=shahedIndex+1;
                end
                
                if (~isempty(strfind(TheoreticalTable(notes,col), 'I')))
                    istTheory(1,istIndex)=str2num(TheoreticalTable(notes,1));
                    istIndex=istIndex+1;
                end
                
                if (~isempty(strfind(TheoreticalTable(notes,col), 'v')))
                    variableTheory(1,variableIndex)=str2num(TheoreticalTable(notes,1));
                    variableIndex=variableIndex+1;
                end
                
                if (~isempty(strfind(TheoreticalTable(notes,col), '0')))
                    secondaryNotesTheory(1,secondaryNotesIndex)=string(TheoreticalTable(notes,1));
                    secondaryNotesIndex=secondaryNotesIndex+1;
                end
            end
            break;
        end % of col loop
    end % of theory files
    
    T=AllTheoriesGushe;
    M=strlength(T);
    M(isnan(M))=0;
    
    if sum(M)>1
        visualizeData(PracticeDataName,AllTheoriesGushe , TheoreticalTable{2}(:,2),m);
    end
end  % of practise file ( Gushes )
