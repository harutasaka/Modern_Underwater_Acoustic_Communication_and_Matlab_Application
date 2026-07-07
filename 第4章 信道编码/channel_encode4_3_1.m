%两种交织和解交织
p = randperm(10);
disp(p)
a = intrlv(10:10:100,p);
disp(a)
b = deintrlv(a,p);
disp(b)

data = [1 2 3 4 5 6];
state = 2121;
intrlvd = randintrlv(data,state);
disp(intrlvd)
deintrlvd = randdeintrlv(intrlvd,state);
disp(deintrlvd)