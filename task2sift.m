clc; %clear screen
clear all; %clear all 
prompt = 'enter directory';
dirm=input(prompt,'s'); %get directory input
cd(dirm); %change to that directory
k='enter resolution r';
r=input(k); %get resolution r
fnames=dir('*.mp4'); %get files with mp4 extension
numfiles=length(fnames); %get number of files
for nf=1:numfiles
	mov=VideoReader(fnames(nf).name); %read video
	frmename=fnames(nf).name; %get video file name
	numFrames=mov.NumberOfFrames; %number of frames
	for i=1:numFrames
		videoFrame=read(mov,i); %read video frame
		grey = rgb2gray(videoFrame); %convert to grayscale		
		[rows columns numberOfColorBands] = size(grey); %get row height columns and colorscale of the image
		brows = floor(rows / r); %find number of rows in each block
		bcols = floor(columns / r); %find number of columns in each block
		[t2,t3] = sift(grey); %get frame and descriptor using sift function 
                cs = size(t2,2); 
		for ro = [brows:brows:rows]
  			for co = [bcols:bcols:columns]
				for l = 1: cs
          				t2f = t2(:, [l]); %reorganize the whole frame array to display for each block
          				t3f = t3(:, [l]); %reorgranize the whole descriptor array to display for each block
          	    			xaxis = t2f(1,1); 
             				yaxis = t2f(2,1);
       					if (((xaxis > (ro - brows)) && xaxis <= ro) && ((yaxis > (co - bcols)) && yaxis <= co)) %logic to output with blocks
      	  					fid=fopen('output_sift.txt','a'); %output file
      	  					fprintf(fid,'\n %s;%d;(%d,%d);\n',frmename,i,(ro/brows)-1,(co/bcols)-1); %output to file
      	  					fprintf(fid,[repmat('%f\t', 1, size(t2f, 2)) ], t2f'); %output to file
       	  					fprintf(fid,';\n'); %output to file
      	  					fprintf(fid,[repmat('%f\t', 1, size(t3f, 2)) '\n'], t3f'); %output to file
       	  					fclose(fid); %close output stream
					end
     				end
  			end
		end
	end
end