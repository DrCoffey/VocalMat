function [tout,rout] = fnMyRose(theta, x)

theta = rem(rem(theta,2*pi)+2*pi,2*pi); % Make sure 0 <= theta <= 2*pi
if length(x)==1,
    x = (0:x-1)*2*pi/x + pi/x;
else
    x = sort(rem(x(:)',2*pi));
end

% Determine bin edges and get histogram
edges = sort(rem([(x(2:end)+x(1:end-1))/2 (x(end)+x(1)+2*pi)/2],2*pi));
edges = [edges edges(1)+2*pi];
nn = histc(rem(theta+2*pi-edges(1),2*pi),edges-edges(1));
nn(end-1) = nn(end-1)+nn(end);
nn(end) = [];

% Form radius values for histogram triangle
if min(size(nn))==1, % Vector
  nn = nn(:); 
end
[m,n] = size(nn);
mm = 4*m;
r = zeros(mm,n);
r(2:4:mm,:) = nn;
r(3:4:mm,:) = nn;

% Form theta values for histogram triangle from triangle centers (xx)
zz = edges;

t = zeros(mm,1);
t(2:4:mm) = zz(1:m);
t(3:4:mm) = zz(2:m+1);

h = polar(t,r);
  
  % Register handles with m-code generator
  if ~isempty(h)
     mcoderegister('Handles',h,'Target',h(1),'Name','rose');
  end
  
  if nargout==1, tout = h; end
  return
end

if min(size(nn))==1,
  tout = t'; rout = r';
else
  tout = t; rout = r;
end

function str=id(str)
str = ['MATLAB:rose:' str];
