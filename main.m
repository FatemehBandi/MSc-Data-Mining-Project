
%___________________________________________________________________%
%                                                                   %
%  Developed in MATLAB R2014a                                       %
%     								    %
%								    %
%                                                                   %
%  programmers: Fatemeh Bandi, Maryam Shahabi, Somayeh Bassiri      %
%								    %
%								    %
%        paper: 					            %
%        A new efficient approach for mining uncertain frequent     %
%	 patterns using minimum data structure without              %
%        false positives                                            %
%								    %
%___________________________________________________________________%




clc
clear
 
[nTrans, nItem, data, TID_data, sig]=preprocessData();


minSup=nTrans*sig;

expSup=zeros(nItem,1);
for i=1:nItem
    idx=data(:,i)~=-1;
    expSup(i)=sum(data(idx,i));
end
[srt_expSup, srt_item]=sort(expSup);
delId=srt_expSup<minSup;
srt_item(delId)=[];
srt_expSup(delId)=[];

R=num2cell(srt_item);
cnt=0;
for i=1:numel(srt_item)
    cnt=cnt+1;
    a=srt_item(i);
    id=data(:,a)~=-1;
    UP_List(cnt).item=a;
    UP_List(cnt).TID=TID_data(id,1);
    UP_List(cnt).Prob=data(id,a);
    UP_List(cnt).max=max(UP_List(cnt).Prob);
    UP_List(cnt).expSup=srt_expSup(i);
end
UFP=UP_List;

for k=1:cnt
    cnt1=1;
    C={};
    pref=UP_List(k).item;
    for l=k+1:cnt
        if (UP_List(k).expSup * UP_List(l).max) >=minSup
            TID_k=UP_List(k).TID;
            size_k=numel(TID_k);
            Prob_k=UP_List(k).Prob;
            
            TID_l=UP_List(l).TID;
            Prob_l=UP_List(l).Prob;
            tbl=[];
            Cur_expSup=0;
            for i=1:numel(TID_k)
                idx=find(TID_k(i)==TID_l);
                if ~isempty(idx)
                    tbl=[tbl; TID_k(i) Prob_k(i)*Prob_l(idx)];
                    Cur_expSup=Cur_expSup+tbl(end,2);
                    if minSup-Cur_expSup>(size_k-i)*UP_List(k).max
                        break
                    end
                end
            end
            if Cur_expSup>=minSup
                CUP_list(cnt1).item=[pref UP_List(l).item];
                CUP_list(cnt1).TID=tbl(:,1);
                CUP_list(cnt1).Prob=tbl(:,2);
                CUP_list(cnt1).max=max(tbl(:,2));
                CUP_list(cnt1).expSup=Cur_expSup;
                
                C{numel(C)+1}= l;
                R{numel(R)+1}=CUP_list(cnt1).item;
                cnt1=cnt1+1;
            end
        end
    end
    
    if numel(C)>=1
        UFP=[UFP CUP_list];    
        if numel(C)>1
            [R,UFP]= LUNA_growth(C,pref,minSup,R,UP_List,CUP_list,UFP);
        end
        clear CUP_list
    end
end
clc
for i=1:numel(UFP)
    TID=UFP(i).TID;
    Prob=UFP(i).Prob;
    T = table(TID,Prob);
    fprintf('item=%s   ; expSup=%2.2f  ; max=%1.2f \n',num2str(UFP(i).item),UFP(i).expSup,UFP(i).max)
    disp(T)
    fprintf('********************************************* \n \n')
end
