

RBG1=[1 0 0];
RBG2=[0 0 1];
RBG3=[1 0 0];
RBG4=[0 0 1];
color1=1;
color2=0;
color3=1;
color4=0;
rng('shuffle')
num=randi([0,100],1,1);
rng('shuffle')
boxLctn=randi([0,100],1,1);
if boxLctn<=50
    if num<=50
        if color1==1
            RBG1(1,1)=0;
            RBG1(1,3)=1;
        elseif color1==0
            RBG1(1,1)=1;
            RBG1(1,3)=0;
        end
    end
    if 50<num
        if color2==1
            RBG2(1,1)=0;
            RBG2(1,3)=1;
        elseif color2==0
            RBG2(1,1)=1;
            RBG2(1,3)=0;
        end
    end
end
if 50<boxLctn
    if num<=50
        if color3==1
            RBG3(1,1)=0;
            RBG3(1,3)=1;
        elseif color3==0
            RBG3(1,1)=1;
            RBG3(1,3)=0;
        end
    end
    if 50<num
        if color4==1
            RBG4(1,1)=0;
            RBG4(1,3)=1;
        elseif color4==0
            RBG4(1,1)=1;
            RBG4(1,3)=0;
        end
    end
end
