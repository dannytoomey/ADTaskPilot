data=[0 0 1;0 0 1;1 0 0;1 0 1];
resp=find(data(4,:)>0);
col=size(data,2);
rt=zeros(1,col);
for count=1:col
    rt(1,count)=data(3,resp(1,count));
end
