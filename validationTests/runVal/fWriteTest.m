


for a=1:5
    for b=1:5
        for c=1:5
            for d=1:5
                test.d=d;
            end
            test.c=c;
        end
        test.b=b;
    end
    test.a=a;               
end

save('testFile.mat','test')
                          