function [nTrans, nItem, data, TID_data, sig]=preprocessData()
disp('                     1: example')
disp('                     2: connect')
disp('                     3: mushroom')
ch=input('                      select? ');

if ch==1
    
    TID_data=[100;200;300;400;500;600;700];
    data=[
        1.0 -1  0.9 0.6 -1  -1  -1  -1
        0.9 0.9 0.7 0.6 0.4 -1  -1  -1
        -1  0.5 0.8 0.9 -1  0.2 0.4 -1
        -1  -1  0.9 -1  0.1 0.5 -1  0.8
        0.4 0.5 0.9 0.3 -1  -1  0.3 0.3
        -1  -1  -1  0.9 0.1 0.6 -1  0.3
        0.9 0.7 0.4 0.6 -1  0.9 -1  -1
        ];
    [nTrans, nItem]=size(data);
    
    sig=0.2;
else
    if ch==2
        dataB=load('connect.dat');
    else
        dataB=load('connect.dat');
    end
    nItem=max(dataB(:));
    
    [nTrans, col]=size(dataB);
    data=-ones(nTrans,nItem);
    for i=1:nTrans
        id=dataB(i,:);
        data(i,id)=rand(1,col);
    end
    TID_data=(1:nTrans)';
    sig=0.4; 
end