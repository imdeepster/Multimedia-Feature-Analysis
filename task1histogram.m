clc;
clear all;
prompt = 'enter directory';
dirm=input(prompt,'s'); %Get input directory
cd(dirm); %Change input directory
p='enter histogram bins';
b=input(p); %Get number of bins
k='enter r size';
r=input(k); %Get resolution for number of cells
fnames=dir('*.mp4'); %Get all mp4 files
numfiles=length(fnames); %Number of video files
for nf=1:numfiles
	mov=VideoReader(fnames(nf).name); %Read video file.
	frmename=fnames(nf).name; %Store file name
	numFrames=mov.NumberOfFrames; %Number of frames in the video file
	for i=1:numFrames
		videoFrame=read(mov,i);  %Read each frame
		grayImage = rgb2gray(videoFrame); 	%Convert the frame into grayscale	
		[rows columns numberOfColorBands] = size(grayImage); %get the component rows columns and colorbands in the frame
		bsr = rows/r;  %Compute number of rows for each cell
		bsc = columns/r; % Computer number of columns for each cell
		rowblock = floor(rows / bsr); %Compute number of rows in each cell
		rowvector = [bsr * ones(1, rowblock)];  
		colblock = floor(columns / bsc); %Computer number of rows in each cell
		colvector = [bsc * ones(1, colblock)];
		ca = mat2cell(grayImage, rowvector, colvector); %divide the frame into its component blocks
		Blocknumber = 1; %part of this code has been reused and mentioned on the project report
		Rnumber = size(ca, 1);  %number of rows in the block
		Cnumber = size(ca, 2); %number of columns in the block
		for r = 1 : Rnumber 
			for c = 1 : Cnumber 
				rgbBlock = ca{r,c}; 
				[rowsB columnsB numberOfColorBandsB] = size(rgbBlock); %component rows columns and colorbands of each block
				his=histcounts(rgbBlock,b); %compute histogram distribution of the block and divide into 4 bins
				fid=fopen('output_chst.txt','a'); %open a output file in append mode
				fprintf(fid,'\n%s;%d;%d;',frmename,i,Blocknumber); %output
				dlmwrite('output_chst.txt',his,'newline','pc','-append'); %output
				Blocknumber = Blocknumber + 1; %increase block number
				fclose(fid); %close file stream
			end
		end
	end
end
