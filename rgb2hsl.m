function [h,s,l] = rgb2hsl(r,g,b)
%RGB2HSL Convert red-green-blue colors to hue-saturation-lightness.
%   H = RGB2HSL(M) converts an RGB color map to an HSL color map.
%   Each map is a matrix with any number of rows, exactly three columns,
%   and elements in the interval 0 to 1.  The columns of the input matrix,
%   M, represent intensity of red, blue and green, respectively.  The
%   columns of the resulting output matrix, H, represent hue, saturation
%   and color lightness, respectively.
%
%   HSL = RGB2HSL(RGB) converts the RGB image RGB (3-D array) to the
%   equivalent HSL image HSL (3-D array).
%
%   CLASS SUPPORT
%   -------------
%   If the input is an RGB image, it can be of class uint8, uint16, or 
%   double; the output image is of class double.  If the input is a 
%   colormap, the input and output colormaps are both of class double.
% 
%   See also HSL2RGB, COLORMAP, RGBPLOT. 

%   Undocumented syntaxes:
%   [H,S,L] = RGB2HSL(R,G,B) converts the RGB image R,G,B to the
%   equivalent HSL image H,S,L.
%
%   HSL = RGB2HSL(R,G,B) converts the RGB image R,G,B to the 
%   equivalent HSL image stored in the 3-D array (HSL).
%
%   [H,S,L] = RGB2HSL(RGB) converts the RGB image RGB (3-D array) to
%   the equivalent HSL image H,S,L.

switch nargin
  case 1,
     if isa(r, 'uint8'), 
        r = double(r) / 255; 
     elseif isa(r, 'uint16')
        r = double(r) / 65535;
     end
  case 3,
     if isa(r, 'uint8'), 
        r = double(r) / 255; 
     elseif isa(r, 'uint16')
        r = double(r) / 65535;
     end
     
     if isa(g, 'uint8'), 
        g = double(g) / 255; 
     elseif isa(g, 'uint16')
        g = double(g) / 65535;
     end
     
     if isa(b, 'uint8'), 
        b = double(b) / 255; 
     elseif isa(b, 'uint16')
        b = double(b) / 65535;
     end
     
  otherwise,
      error('jcb:rgb2hsl:WrongInputNum', 'Wrong number of input arguments.');
end
  
threeD = (ndims(r)==3); % Determine if input includes a 3-D array

if threeD,
  g = r(:,:,2); b = r(:,:,3); r = r(:,:,1);
  siz = size(r);
  r = r(:); g = g(:); b = b(:);
elseif nargin==1,
  g = r(:,2); b = r(:,3); r = r(:,1);
  siz = size(r);
else
  if ~isequal(size(r),size(g),size(b)), 
    error('jcb:rgb2hsl:InputSizeMismatch', 'R,G,B must all be the same size.');
  end
  siz = size(r);
  r = r(:); g = g(:); b = b(:);
end

% intermediate values used in the calculation
M = max(max(r,g),b);
m = min(min(r,g),b);
C = M-m;

l = (M+m)/2;
h = zeros(size(l));

k = ~l;         % avoid div-by-0 errors for zero lightness points
l = l+k;
s = (M-m)./(1-abs(2*l-1)+eps);
l = (~k).*l;    % reset l=0 points. saturations for these will be reset later.

z = ~s;
s = s + z;      % avoid div-by-0 errors for zero saturation
k = find(M == r);
h(k) = (g(k) - b(k))./(C(k)+eps);
k = find(M == g);
h(k) = 2 + (b(k) - r(k))./(C(k)+eps);
k = find(M == b);
h(k) = 4 + (r(k) - g(k))./(C(k)+eps);
h = h/6;
k = find(h < 0);
h(k) = h(k) + 1;
h=(~z).*h;      % set h=0 for zero-saturation points

s(~l)   = 0;    % set s=0 for l==0 (i.e. black)
s(l==1) = 0;    % set s=0 for l==1 (i.e. white)

if nargout<=1,
  if (threeD || nargin==3),
    h = reshape(h,siz);
    s = reshape(s,siz);
    l = reshape(l,siz);
    h=cat(3,h,s,l);
  else
    h=[h s l];
  end
else
  h = reshape(h,siz);
  s = reshape(s,siz);
  l = reshape(l,siz);
end