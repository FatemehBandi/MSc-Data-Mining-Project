function [R, UFP]=LUNA_growth(C,pref,minSup,R,UP_List,CUP_list,UFP)

for j=1:numel(C)
    cnt1=1;
    Cp={};
    ck=C{j};
    pref_p=[pref UP_List(ck).item];
    for l=j+1:numel(C)
        cl=C{l};
        if CUP_list(j).expSup*UP_List(cl).max >=minSup
            TID_k=CUP_list(j).TID;
            size_k=numel(TID_k);
            Prob_k=CUP_list(j).Prob;
            
            TID_l=UP_List(cl).TID;
            Prob_l=UP_List(cl).Prob;
            tbl=[];
            Cur_expSup=0;
            for i=1:numel(TID_k)
                idx=find(TID_k(i)==TID_l);
                if ~isempty(idx)
                    tbl=[tbl; TID_k(i) Prob_k(i)*Prob_l(idx)];
                    Cur_expSup=Cur_expSup+tbl(end,2);
                    if minSup-Cur_expSup>(size_k-i)*CUP_list(j).max
                        break
                    end
                end
            end
            if Cur_expSup>=minSup
                CUP_list1(cnt1).item=[pref_p UP_List(cl).item];
                CUP_list1(cnt1).TID=tbl(:,1);
                CUP_list1(cnt1).Prob=tbl(:,2);
                CUP_list1(cnt1).max=max(tbl(:,2));
                CUP_list1(cnt1).expSup=Cur_expSup;
                
                Cp{numel(Cp)+1}= cl;
                R{numel(R)+1}=CUP_list1(cnt1).item;
                cnt1=cnt1+1;
            end
        end
    end
    if numel(Cp)>=1
        UFP=[UFP CUP_list1];
        if numel(Cp)>1
            [R,UFP]= LUNA_growth(Cp,pref_p,minSup,R,UP_List,CUP_list1, UFP);
        end
        clear CUP_list1
    end
end