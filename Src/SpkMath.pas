unit SpkMath;

interface

{$I Spk.inc}
{ TODO: Consider if all implicit casts make sense }

uses
  Types, Math, SysUtils;

const
  NUM_ZERO = 1E-12;

type
  TRectCorner = (rcLeftTop, rcRightTop, rcLeftBottom, rcRightBottom);

  // Two-dimensional vector routines
  T2DIntVector = record
    x, y: Integer;
  public
    constructor Create(Ax, Ay: Integer);
    class operator Implicit(i: Integer): T2DIntVector;
    class operator Explicit(i: Integer): T2DIntVector;
    class operator Implicit(vector: T2DIntVector): string;
    class operator Explicit(vector: T2DIntVector): string;
    class operator Implicit(point: TPoint): T2DIntVector;
    class operator Explicit(point: TPoint): T2DIntVector;
    class operator Implicit(vector: T2DIntVector): TPoint;
    class operator Explicit(vector: T2DIntVector): TPoint;
    class operator Positive(vector: T2DIntVector): T2DIntVector;
    class operator Negative(vector: T2DIntVector): T2DIntVector;
    class operator Add(left, right: T2DIntVector): T2DIntVector;
    class operator Subtract(left, right: T2DIntVector): T2DIntVector;
    class operator Multiply(left, right: T2DIntVector): Integer;
    class operator Multiply(scalar: Integer; right: T2DIntVector): T2DIntVector;
    class operator Multiply(left: T2DIntVector; scalar: Integer): T2DIntVector;
    class operator Trunc(value: T2DIntVector): T2DIntVector;
    class operator Round(value: T2DIntVector): T2DIntVector;
    function DistanceTo(AVector: T2DIntVector): double;
    function Length: extended;
  end;

  // A point in two-dimensional space (integer numbers)
  T2DIntPoint = T2DIntVector;

  // Rectangle in two-dimensional space (integer numbers)
  T2DIntRect = record
  public
    constructor Create(ALeft, ATop, ARight, ABottom: Integer); overload;
    constructor Create(ATopLeft: T2DIntVector; ABottomRight: T2DIntVector); overload;
    class operator Implicit(ARect: T2DIntRect): TRect;
    class operator Explicit(ARect: T2DIntRect): TRect;
    class operator Implicit(ARect: TRect): T2DIntRect;
    class operator Explicit(ARect: TRect): T2DIntRect;
    class operator Implicit(ARect: T2DIntRect): string;
    class operator Explicit(ARect: T2DIntRect): string;
    class operator Add(ARect: T2DIntRect; AVector: T2DIntVector): T2DIntRect;
    class operator Add(AVector: T2DIntVector; ARect: T2DIntRect): T2DIntRect;
    class operator Subtract(ARect: T2DIntRect; AVector: T2DIntVector): T2DIntRect;
    class operator Subtract(AVector: T2DIntVector; ARect: T2DIntRect): T2DIntRect;
    function Contains(APoint: T2DIntPoint): Boolean;
    function ForWinAPI: TRect;
    function GetVertex(ACorner: TRectCorner): T2DIntVector;
    function Height: Integer;
    function IntersectsWith(ARect: T2DIntRect): boolean; overload;
    function IntersectsWith(ARect: T2DIntRect; var Intersection: T2DIntRect): boolean; overload;
    function Moved(AVector: T2DIntVector): T2DIntRect; overload;
    function Moved(dx, dy: Integer): T2DIntRect; overload;
    function Width: Integer;
    procedure ExpandBy(APoint: T2DIntPoint);
    procedure Move(AVector: T2DIntVector); overload;
    procedure Move(dx, dy: Integer); overload;
    procedure Split(var LeftTop, RightTop, LeftBottom, RightBottom: T2DIntRect);
    case Integer of
      0:
        (Left, Top, Right, Bottom: Integer);
      1:
        (TopLeft: T2DIntVector; BottomRight: T2DIntVector);
  end;

  // Vector in two-dimensional space (floating point numbers)
  // todo change from extended to double
  T2DVector = record
    x, y: extended;
  public
    constructor Create(Ax, Ay: extended);
    class operator Implicit(i: Integer): T2DVector;
    class operator Explicit(i: Integer): T2DVector;
    class operator Implicit(e: extended): T2DVector;
    class operator Explicit(e: extended): T2DVector;
    class operator Implicit(vector: T2DVector): string;
    class operator Explicit(vector: T2DVector): string;
    class operator Implicit(vector: T2DIntVector): T2DVector;
    class operator Explicit(vector: T2DIntVector): T2DVector;
    class operator Implicit(vector: T2DVector): T2DIntVector;
    class operator Explicit(vector: T2DVector): T2DIntVector;
    class operator Positive(vector: T2DVector): T2DVector;
    class operator Negative(vector: T2DVector): T2DVector;
    class operator Add(left, right: T2DVector): T2DVector;
    class operator Subtract(left, right: T2DVector): T2DVector;
    class operator Multiply(left, right: T2DVector): extended;
    class operator Multiply(scalar: extended; right: T2DVector): T2DVector;
    class operator Multiply(left: T2DVector; scalar: extended): T2DVector;
    class operator Divide(left: T2DVector; scalar: extended): T2DVector;
    class operator Trunc(vector: T2DVector): T2DIntVector;
    class operator Round(vector: T2DVector): T2DIntVector;
    function CrossProductWith(AVector: T2DVector): extended;
    function DistanceFromAxis(APoint: T2DVector; AVector: T2DVector): extended;
    function DownNormal: T2DVector;
    function Length: extended;
    function LiesInsideCircle(APoint: T2DVector; radius: extended): boolean;
    function Normalized: T2DVector;
    function OrientationWith(AVector: T2DVector): Integer;
    function ProjectedTo(vector: T2DVector): T2DVector;
    function Scale(dx, dy: extended): T2DVector;
    function UpNormal: T2DVector;
    procedure Normalize;
    procedure ProjectTo(vector: T2DVector);
  end;

  // A point in two-dimensional space (floating point numbers)
  T2DPoint = T2DVector;

  // Rectangle in two-dimensional space (floating point numbers)
  T2DRect = record
  public
    constructor Create(ALeft, ATop, ARight, ABottom: extended); overload;
    constructor Create(ATopLeft: T2DVector; ABottomRight: T2DVector); overload;
    class operator Implicit(ARect: T2DRect): TRect;
    class operator Explicit(ARect: T2DRect): TRect;
    class operator Implicit(ARect: TRect): T2DRect;
    class operator Explicit(ARect: TRect): T2DRect;
    class operator Implicit(ARect: T2DRect): T2DIntRect;
    class operator Explicit(ARect: T2DRect): T2DIntRect;
    class operator Implicit(ARect: T2DIntRect): T2DRect;
    class operator Explicit(ARect: T2DIntRect): T2DRect;
    class operator Implicit(ARect: T2DRect): string;
    class operator Explicit(ARect: T2DRect): string;
    function Contains(APoint: T2DPoint): boolean;
    function GetVertex(ACorner: TRectCorner): T2DVector;
    function Height: extended;
    function IntersectsWith(ARect: T2DRect): boolean;
    function Moved(dx, dy: extended): T2DRect; overload;
    function Moved(vector: T2DVector): T2DRect; overload;
    function Width: extended;
    procedure ExpandBy(APoint: T2DPoint);
    procedure Move(dx, dy: extended); overload;
    procedure Move(vector: T2DVector); overload;
    procedure SetCenteredHeight(ANewHeight: extended);
    procedure SetCenteredWidth(ANewWidth: extended);
    procedure Split(var LeftTop, RightTop, LeftBottom, RightBottom: T2DRect);
    case integer of
      0:
        (left, Top, right, Bottom: extended);
      1:
        (TopLeft: T2DVector; BottomRight: T2DVector);
  end;

  // Vector in three-dimensional space (floating point numbers)
  T3DVector = record
    x, y, z: extended;
  public
    constructor Create(Ax, Ay, Az: extended);
    class operator Implicit(i: Integer): T3DVector;
    class operator Explicit(i: Integer): T3DVector;
    class operator Implicit(e: extended): T3DVector;
    class operator Explicit(e: extended): T3DVector;
    class operator Implicit(vector: T2DIntVector): T3DVector;
    class operator Explicit(vector: T2DIntVector): T3DVector;
    class operator Implicit(vector: T2DVector): T3DVector;
    class operator Explicit(vector: T2DVector): T3DVector;
    class operator Implicit(vector: T3DVector): string;
    class operator Explicit(vector: T3DVector): string;
    class operator Negative(vector: T3DVector): T3DVector;
    class operator Positive(vector: T3DVector): T3DVector;
    class operator Add(left, right: T3DVector): T3DVector;
    class operator Subtract(left, right: T3DVector): T3DVector;
    class operator Multiply(left, right: T3DVector): extended;
    class operator Multiply(scalar: extended; right: T3DVector): T3DVector;
    class operator Multiply(left: T3DVector; scalar: extended): T3DVector;
    class operator Divide(left: T3DVector; scalar: extended): T3DVector;
    function DistanceFromAxis(APoint: T3DVector; AVector: T3DVector): extended;
    function DownNormalTo(vector: T3DVector): T3DVector;
    function Length: extended;
    function LiesInsideSphere(APoint: T3DVector; radius: extended): boolean;
    function Normalized: T3DVector;
    function ProjectedTo(vector: T3DVector): T3DVector;
    function Scale(dx, dy, dz: extended): T3DVector;
    function UpNormalTo(vector: T3DVector): T3DVector;
    procedure Normalize;
    procedure ProjectTo(vector: T3DVector);
  end;

implementation

{ T2DIntVector }

class operator T2DIntVector.Add(left, right: T2DIntVector): T2DIntVector;
begin
  Result.x := left.x - right.x;
  Result.y := left.y - right.y;
end;

constructor T2DIntVector.Create(Ax, Ay: Integer);
begin
  Self.x := Ax;
  Self.y := Ay;
end;

function T2DIntVector.DistanceTo(AVector: T2DIntVector): double;
begin
  Result := sqrt(sqr(Self.x - AVector.x) + sqr(Self.y - AVector.y));
end;

class operator T2DIntVector.Explicit(i: Integer): T2DIntVector;
begin
  Result.x := i;
  Result.y := 0;
end;

class operator T2DIntVector.Explicit(vector: T2DIntVector): string;
begin
  Result := '[x=' + IntToStr(vector.x) + '; y=' + IntToStr(vector.y) + ']';
end;

class operator T2DIntVector.Implicit(vector: T2DIntVector): string;
begin
  Result := '[x=' + IntToStr(vector.x) + '; y=' + IntToStr(vector.y) + ']';
end;

class operator T2DIntVector.Implicit(i: Integer): T2DIntVector;
begin
  Result.x := i;
  Result.y := 0;
end;

function T2DIntVector.Length: extended;
begin
  Result := sqrt(sqr(Self.x) + sqr(Self.y));
end;

class operator T2DIntVector.Multiply(left: T2DIntVector; scalar: Integer): T2DIntVector;
begin
  Result.x := left.x * scalar;
  Result.y := left.y * scalar;
end;

class operator T2DIntVector.Multiply(left, right: T2DIntVector): Integer;
begin
  Result := left.x * right.x + left.y * right.y;
end;

class operator T2DIntVector.Multiply(scalar: Integer; right: T2DIntVector): T2DIntVector;
begin
  Result.x := scalar * right.x;
  Result.y := scalar * right.y;
end;

class operator T2DIntVector.Negative(vector: T2DIntVector): T2DIntVector;
begin
  Result.x := -vector.x;
  Result.y := -vector.y;
end;

class operator T2DIntVector.Positive(vector: T2DIntVector): T2DIntVector;
begin
  Result.x := vector.x;
  Result.y := vector.y;
end;

class operator T2DIntVector.Round(value: T2DIntVector): T2DIntVector;
begin
  Result.x := value.x;
  Result.y := value.y;
end;

class operator T2DIntVector.Subtract(left, right: T2DIntVector): T2DIntVector;
begin
  Result.x := left.x - right.x;
  Result.y := left.y - right.y;
end;

class operator T2DIntVector.Trunc(value: T2DIntVector): T2DIntVector;
begin
  Result.x := value.x;
  Result.y := value.y;
end;

class operator T2DIntVector.Explicit(point: TPoint): T2DIntVector;
begin
  Result.x := point.x;
  Result.y := point.y;
end;

class operator T2DIntVector.Explicit(vector: T2DIntVector): TPoint;
begin
  Result.x := vector.x;
  Result.y := vector.y;
end;

class operator T2DIntVector.Implicit(point: TPoint): T2DIntVector;
begin
  Result.x := point.x;
  Result.y := point.y;
end;

class operator T2DIntVector.Implicit(vector: T2DIntVector): TPoint;
begin
  Result.x := vector.x;
  Result.y := vector.y;
end;

{ T2DVector }

class operator T2DVector.Add(left, right: T2DVector): T2DVector;
begin
  Result.x := left.x + right.x;
  Result.y := left.y + right.y;
end;

constructor T2DVector.Create(Ax, Ay: extended);
begin
  Self.x := Ax;
  Self.y := Ay;
end;


function T2DVector.DistanceFromAxis(APoint, AVector: T2DVector): extended;
var
  temp, proj: T2DVector;
begin
  temp := self - APoint;
  proj := temp.ProjectedTo(AVector);
  Result := (temp - proj).Length;
end;

class operator T2DVector.Divide(left: T2DVector; scalar: extended): T2DVector;
begin
  if abs(scalar) < NUM_ZERO then
    raise exception.Create('T2DVector.Divide: Division by zero!');
  Result.x := left.x / scalar;
  Result.y := left.y / scalar;
end;

function T2DVector.DownNormal: T2DVector;
var
  len: extended;
begin
  len := Self.Length;
  if len < NUM_ZERO then
    raise exception.Create('T2DVector.DownNormal: Cannot normalize a vector of zero length!');

  if Self.x > 0 then
  begin
    Result.x := Self.y / len;
    Result.y := -Self.x / len;
  end
  else
  begin
    Result.x := -Self.y / len;
    Result.y := Self.x / len;
  end;
end;

class operator T2DVector.Explicit(vector: T2DVector): string;
begin
  Result := '[x=' + FloatToStr(vector.x) + '; y=' + FloatToStr(vector.y) + ']';
end;

class operator T2DVector.Explicit(i: Integer): T2DVector;
begin
  Result.x := i;
  Result.y := 0;
end;

class operator T2DVector.Explicit(e: extended): T2DVector;
begin
  Result.x := e;
  Result.y := 0;
end;

class operator T2DVector.Explicit(vector: T2DIntVector): T2DVector;
begin
  Result.x := vector.x;
  Result.y := vector.y;
end;

class operator T2DVector.Explicit(vector: T2DVector): T2DIntVector;
begin
  Result.x := Round(vector.x);
  Result.y := Round(vector.y);
end;

class operator T2DVector.Implicit(vector: T2DVector): string;
begin
  Result := '[x=' + FloatToStr(vector.x) + '; y=' + FloatToStr(vector.y) + ']';
end;

class operator T2DVector.Implicit(vector: T2DIntVector): T2DVector;
begin
  Result.x := vector.x;
  Result.y := vector.y;
end;

class operator T2DVector.Implicit(i: Integer): T2DVector;
begin
  Result.x := i;
  Result.y := 0;
end;

class operator T2DVector.Implicit(e: extended): T2DVector;
begin
  Result.x := e;
  Result.y := 0;
end;

class operator T2DVector.Implicit(vector: T2DVector): T2DIntVector;
begin
  Result.x := Round(vector.x);
  Result.y := Round(vector.y);
end;

function T2DVector.Length: extended;
begin
  Result := sqrt(sqr(Self.x) + sqr(Self.y));
end;

function T2DVector.LiesInsideCircle(APoint: T2DPoint; radius: extended): boolean;
var
  temp: T2DVector;
begin
  temp := APoint - self;
  Result := temp.Length <= radius;
end;

class operator T2DVector.Multiply(left, right: T2DVector): extended;
begin
  Result := left.x * right.x + left.y * right.y;
end;

class operator T2DVector.Multiply(left: T2DVector; scalar: extended): T2DVector;
begin
  Result.x := left.x * scalar;
  Result.y := left.y * scalar;
end;

class operator T2DVector.Multiply(scalar: extended; right: T2DVector): T2DVector;
begin
  Result.x := scalar * right.x;
  Result.y := scalar * right.y;
end;

class operator T2DVector.Negative(vector: T2DVector): T2DVector;
begin
  Result.x := -vector.x;
  Result.y := -vector.y;
end;

procedure T2DVector.Normalize;
var
  len: extended;
begin
  len := Self.Length;
  if len < NUM_ZERO then
    raise Exception.Create('T2DVector.Normalize: The zero vector can not be normalized!');
  Self.x := Self.x / len;
  Self.y := Self.y / len;
end;

function T2DVector.Normalized: T2DVector;
var
  len: extended;
begin
  len := Self.Length;
  if len < NUM_ZERO then
    raise Exception.Create('T2DVector.Normalized: The zero vector standard can not be calculated!');
  Result.x := Self.x / len;
  Result.y := Self.y / len;
end;

function T2DVector.OrientationWith(AVector: T2DVector): Integer;
var
  product: extended;
begin
  product := Self.CrossProductWith(AVector);
  if product < NUM_ZERO then
    Result := -1
  else if product > NUM_ZERO then
    Result := 1
  else
    Result := 0;
end;

class operator T2DVector.Positive(vector: T2DVector): T2DVector;
begin
  Result.x := vector.x;
  Result.y := vector.y;
end;

function T2DVector.CrossProductWith(AVector: T2DVector): extended;
begin
  Result := Self.x * AVector.y - Self.y * AVector.x;
end;

function T2DVector.ProjectedTo(vector: T2DVector): T2DVector;
var
  product: extended;
  len: extended;
begin
  len := vector.Length;
  if abs(len) < NUM_ZERO then
    raise exception.Create('T2DVector.ProjectedTo: It can not be cast on the zero vector!');

  product := Self.x * vector.x + Self.y * vector.y;
  Result.x := (vector.x * product) / sqr(len);
  Result.y := (vector.y * product) / sqr(len);
end;

procedure T2DVector.ProjectTo(vector: T2DVector);
var
  product: extended;
  len: extended;
begin
  len := vector.Length;
  if abs(len) < NUM_ZERO then
    raise exception.Create('T2DVector.ProjectTo: It can not be cast on the zero vector!');

  product := Self.x * vector.x + Self.y * vector.y;

  Self.x := (vector.x * product) / sqr(len);
  Self.y := (vector.y * product) / sqr(len);
end;

class operator T2DVector.Round(vector: T2DVector): T2DIntVector;
begin
  Result.x := Round(vector.x);
  Result.y := Round(vector.y);
end;

function T2DVector.Scale(dx, dy: extended): T2DVector;
begin
  Result.x := Self.x * dx;
  Result.y := Self.y * dy;
end;

class operator T2DVector.Subtract(left, right: T2DVector): T2DVector;
begin
  Result.x := left.x - right.x;
  Result.y := left.y - right.y;
end;

class operator T2DVector.Trunc(vector: T2DVector): T2DIntVector;
begin
  Result.x := Trunc(vector.x);
  Result.y := Trunc(vector.y);
end;

function T2DVector.UpNormal: T2DVector;
var
  len: extended;
begin
  len := Self.Length;
  if len < NUM_ZERO then
    raise exception.Create('T2DVector.UpNormal: It can not calculate normal to the null vector!');

  if Self.x > 0 then
  begin
    Result.x := -Self.y / len;
    Result.y := Self.x / len;
  end
  else
  begin
    Result.x := Self.y / len;
    Result.y := -Self.x / len;
  end;
end;

{ T3DVector }

class operator T3DVector.Add(left, right: T3DVector): T3DVector;
begin
  Result.x := left.x + right.x;
  Result.y := left.y + right.y;
  Result.z := left.z + right.z;
end;

constructor T3DVector.Create(Ax, Ay, Az: extended);
begin
  Self.x := Ax;
  Self.y := Ay;
  Self.z := Az;
end;

function T3DVector.DistanceFromAxis(APoint, AVector: T3DVector): extended;
var
  temp, proj: T3DVector;
begin
  temp := self - APoint;
  proj := temp.ProjectedTo(AVector);
  Result := (temp - proj).Length;
end;

class operator T3DVector.Divide(left: T3DVector; scalar: extended): T3DVector;
begin
  if abs(scalar) < NUM_ZERO then
    raise exception.Create('T3DVector.Divide: Division by zero!');
  Result.x := left.x / scalar;
  Result.y := left.y / scalar;
  Result.z := left.z / scalar;
end;

function T3DVector.DownNormalTo(vector: T3DVector): T3DVector;
var
  len: extended;
begin
  Result.x := Self.y * vector.z - Self.z * vector.y;
  Result.y := -(Self.x * vector.z - Self.z * vector.x);
  Result.z := Self.x * vector.y - Self.y * vector.x;
  len := Result.Length;
  if len < NUM_ZERO then
    raise exception.Create('T3DVector.DownNormalTo: Vector length is zero!');
  Result.x := Result.x / len;
  Result.y := Result.y / len;
  Result.z := Result.z / len;

  if Result.y > 0 then
  begin
    Result.x := -Result.x;
    Result.y := -Result.y;
    Result.z := -Result.z;
  end;
end;

class operator T3DVector.Explicit(vector: T2DIntVector): T3DVector;
begin
  Result.x := vector.x;
  Result.y := vector.y;
  Result.z := 0;
end;

class operator T3DVector.Explicit(i: Integer): T3DVector;
begin
  Result.x := i;
  Result.y := 0;
  Result.z := 0;
end;

class operator T3DVector.Explicit(e: extended): T3DVector;
begin
  Result.x := e;
  Result.y := 0;
  Result.z := 0;
end;

class operator T3DVector.Explicit(vector: T2DVector): T3DVector;
begin
  Result.x := vector.x;
  Result.y := vector.y;
  Result.z := 0;
end;

class operator T3DVector.Explicit(vector: T3DVector): string;
begin
  Result := '[x=' + FloatToStr(vector.x) + '; y=' + FloatToStr(vector.y) + '; z=' + FloatToStr(vector.z) + ']';
end;

class operator T3DVector.Implicit(vector: T2DIntVector): T3DVector;
begin
  Result.x := vector.x;
  Result.y := vector.y;
  Result.z := 0;
end;

class operator T3DVector.Implicit(vector: T2DVector): T3DVector;
begin
  Result.x := vector.x;
  Result.y := vector.y;
  Result.z := 0;
end;

class operator T3DVector.Implicit(i: Integer): T3DVector;
begin
  Result.x := i;
  Result.y := 0;
  Result.z := 0;
end;

class operator T3DVector.Implicit(e: extended): T3DVector;
begin
  Result.x := e;
  Result.y := 0;
  Result.z := 0;
end;

class operator T3DVector.Implicit(vector: T3DVector): string;
begin
  Result := '[x=' + FloatToStr(vector.x) + '; y=' + FloatToStr(vector.y) + '; z=' + FloatToStr(vector.z) + ']';
end;

function T3DVector.Length: extended;
begin
  Result := sqrt(sqr(Self.x) + sqr(Self.y) + sqr(Self.z));
end;

function T3DVector.LiesInsideSphere(APoint: T3DVector; radius: extended): boolean;
var
  temp: T3DVector;
begin
  temp := APoint - self;
  Result := temp.Length <= radius;
end;

class operator T3DVector.Multiply(left: T3DVector; scalar: extended): T3DVector;
begin
  Result.x := left.x * scalar;
  Result.y := left.y * scalar;
  Result.z := left.z * scalar;
end;

class operator T3DVector.Multiply(scalar: extended; right: T3DVector): T3DVector;
begin
  Result.x := scalar * right.x;
  Result.y := scalar * right.y;
  Result.z := scalar * right.z;
end;

class operator T3DVector.Multiply(left, right: T3DVector): extended;
begin
  Result := left.x * right.x + left.y * right.y + left.z * right.z;
end;

class operator T3DVector.Negative(vector: T3DVector): T3DVector;
begin
  Result.x := -vector.x;
  Result.y := -vector.y;
  Result.z := -vector.z;
end;

procedure T3DVector.Normalize;
var
  len: extended;
begin
  len := Self.Length;
  if len < NUM_ZERO then
    raise exception.Create('T3DVector.Normalize: The zero vector can not be normalized!');
  Self.x := Self.x / len;
  Self.y := Self.y / len;
  Self.z := Self.z / len;
end;

function T3DVector.Normalized: T3DVector;
var
  len: extended;
begin
  len := Self.Length;
  if len < NUM_ZERO then
    raise exception.Create('T3DVector.Normalized: The zero vector standard can not be calculated!');
  Result.x := Self.x / len;
  Result.y := Self.y / len;
  Result.z := Self.z / len;
end;

class operator T3DVector.Positive(vector: T3DVector): T3DVector;
begin
  Result.x := vector.x;
  Result.y := vector.y;
  Result.z := vector.z;
end;

function T3DVector.ProjectedTo(vector: T3DVector): T3DVector;
var
  product: extended;
  len: extended;
begin
  len := vector.Length;
  if abs(len) < NUM_ZERO then
    raise exception.Create('T3DVector.ProjectedTo: It can not be cast on the zero vector!');

  product := Self.x * vector.x + Self.y * vector.y + Self.z * vector.z;
  Result.x := (vector.x * product) / sqr(len);
  Result.y := (vector.y * product) / sqr(len);
  Result.z := (vector.z * product) / sqr(len);
end;

procedure T3DVector.ProjectTo(vector: T3DVector);
var
  product: extended;
  len: extended;
begin
  len := vector.Length;
  if abs(len) < NUM_ZERO then
    raise exception.Create('T3DVector.ProjectTo: It can not be cast on the zero vector!');

  product := Self.x * vector.x + Self.y * vector.y + Self.z * vector.z;
  Self.x := (vector.x * product) / sqr(len);
  Self.y := (vector.y * product) / sqr(len);
  Self.z := (vector.z * product) / sqr(len);
end;

function T3DVector.Scale(dx, dy, dz: extended): T3DVector;
begin
  Result.x := Self.x * dx;
  Result.y := Self.y * dx;
  Result.z := Self.z * dx;
end;

class operator T3DVector.Subtract(left, right: T3DVector): T3DVector;
begin
  Result.x := left.x - right.x;
  Result.y := left.y - right.y;
  Result.z := left.z - right.z;
end;

function T3DVector.UpNormalTo(vector: T3DVector): T3DVector;
var
  len: extended;
begin
  Result.x := Self.y * vector.z - Self.z * vector.y;
  Result.y := -(Self.x * vector.z - Self.z * vector.x);
  Result.z := Self.x * vector.y - Self.y * vector.x;

  len := Result.Length;
  if len < NUM_ZERO then
    raise exception.Create('T3DVector.UpNormalTo: I can not calculate normal: vectors lie on a common straight line!');
  Result.x := Result.x / len;
  Result.y := Result.y / len;
  Result.z := Result.z / len;

  if Result.y < 0 then
  begin
    Result.x := -Result.x;
    Result.y := -Result.y;
    Result.z := -Result.z;
  end;
end;

{ T2DIntRect }

class operator T2DIntRect.Add(AVector: T2DIntVector; ARect: T2DIntRect): T2DIntRect;
begin
  Result := T2DIntRect.Create(ARect.Left + AVector.x, ARect.Top + AVector.y, ARect.Right + AVector.x, ARect.Bottom + AVector.y);
end;

class operator T2DIntRect.Add(ARect: T2DIntRect; AVector: T2DIntVector): T2DIntRect;
begin
  Result := T2DIntRect.Create(ARect.Left + AVector.x, ARect.Top + AVector.y, ARect.Right + AVector.x, ARect.Bottom + AVector.y);
end;

function T2DIntRect.Contains(APoint: T2DIntPoint): boolean;
begin
  Result := (APoint.x >= Self.Left) and (APoint.x <= Self.Right) and (APoint.y >= Self.Top) and (APoint.y <= Self.Bottom);
end;

constructor T2DIntRect.Create(ALeft, ATop, ARight, ABottom: Integer);
begin
  Self.Left := ALeft;
  Self.Top := ATop;
  Self.Right := ARight;
  Self.Bottom := ABottom;
end;

constructor T2DIntRect.Create(ATopLeft, ABottomRight: T2DIntVector);
begin
  Self.TopLeft := ATopLeft;
  Self.BottomRight := ABottomRight;
end;

class operator T2DIntRect.Explicit(ARect: T2DIntRect): TRect;
begin
  Result.left := ARect.Left;
  Result.Top := ARect.Top;
  Result.right := ARect.Right;
  Result.Bottom := ARect.Bottom;
end;

procedure T2DIntRect.ExpandBy(APoint: T2DIntPoint);
begin
  Self.Left := min(Self.Left, APoint.x);
  Self.Right := max(Self.Right, APoint.x);
  Self.Top := min(Self.Top, APoint.y);
  Self.Bottom := max(Self.Bottom, APoint.y);
end;

class operator T2DIntRect.Explicit(ARect: TRect): T2DIntRect;
begin
  Result.Left := ARect.left;
  Result.Top := ARect.Top;
  Result.Right := ARect.right;
  Result.Bottom := ARect.Bottom;
end;

function T2DIntRect.GetVertex(ACorner: TRectCorner): T2DIntVector;
begin
  case ACorner of
    rcLeftTop:
      Result := T2DIntVector.Create(Self.Left, Self.Top);
    rcRightTop:
      Result := T2DIntVector.Create(Self.Right, Self.Top);
    rcLeftBottom:
      Result := T2DIntVector.Create(Self.Left, Self.Bottom);
    rcRightBottom:
      Result := T2DIntVector.Create(Self.Right, Self.Bottom);
  end;
end;

function T2DIntRect.Height: Integer;
begin
  Result := Self.Bottom - Self.Top + 1;
end;

class operator T2DIntRect.Implicit(ARect: T2DIntRect): TRect;
begin
  Result.left := ARect.Left;
  Result.Top := ARect.Top;
  Result.right := ARect.Right;
  Result.Bottom := ARect.Bottom;
end;

class operator T2DIntRect.Implicit(ARect: TRect): T2DIntRect;
begin
  Result.Left := ARect.left;
  Result.Top := ARect.Top;
  Result.Right := ARect.right;
  Result.Bottom := ARect.Bottom;
end;

class operator T2DIntRect.Implicit(ARect: T2DIntRect): string;
begin
  Result := '(' + IntToStr(ARect.Left) + ', ' + IntToStr(ARect.Top) + ', ' + IntToStr(ARect.Right) + ', ' + IntToStr(ARect.Bottom) + ')';
end;

function T2DIntRect.IntersectsWith(ARect: T2DIntRect; var Intersection: T2DIntRect): boolean;
var
  XStart, XWidth, YStart, YWidth: Integer;
begin
  if Self.Left <= ARect.Left then
  begin
    if ARect.Left <= Self.Right then
    begin
      XStart := ARect.Left;
      XWidth := min(ARect.Right, Self.Right) - ARect.Left + 1;
    end
    else
    begin
      XStart := 0;
      XWidth := 0;
    end;
  end
  else
  begin
    if Self.Left <= ARect.Right then
    begin
      XStart := Self.Left;
      XWidth := min(ARect.Right, Self.Right) - Self.Left + 1;
    end
    else
    begin
      XStart := 0;
      XWidth := 0;
    end;
  end;

  if Self.Top <= ARect.Top then
  begin
    if ARect.Top <= Self.Bottom then
    begin
      YStart := ARect.Top;
      YWidth := min(ARect.Bottom, Self.Bottom) - ARect.Top + 1;
    end
    else
    begin
      YStart := 0;
      YWidth := 0;
    end;
  end
  else
  begin
    if Self.Top <= ARect.Bottom then
    begin
      YStart := Self.Top;
      YWidth := min(ARect.Bottom, Self.Bottom) - Self.Top + 1;
    end
    else
    begin
      YStart := 0;
      YWidth := 0;
    end;
  end;

  Intersection := T2DIntRect.Create(XStart, YStart, XStart + XWidth - 1, YStart + YWidth - 1);
  Result := (XWidth > 0) and (YWidth > 0);
end;

function T2DIntRect.IntersectsWith(ARect: T2DIntRect): boolean;
begin
  Result := (max(ARect.Left, Self.Left) <= min(ARect.Right, Self.Right)) and (max(ARect.Top, Self.Top) <= min(ARect.Bottom, Self.Bottom));
end;

procedure T2DIntRect.Move(dx, dy: Integer);
begin
  inc(Left, dx);
  inc(Right, dx);
  inc(Top, dy);
  inc(Bottom, dy);
end;

procedure T2DIntRect.Move(AVector: T2DIntVector);
begin
  inc(Self.Left, AVector.x);
  inc(Self.Right, AVector.x);
  inc(Self.Top, AVector.y);
  inc(Self.Bottom, AVector.y);
end;

function T2DIntRect.Moved(AVector: T2DIntVector): T2DIntRect;
begin
  Result.Left := Self.Left + AVector.x;
  Result.Right := Self.Right + AVector.x;
  Result.Top := Self.Top + AVector.y;
  Result.Bottom := Self.Bottom + AVector.y;
end;

procedure T2DIntRect.Split(var LeftTop, RightTop, LeftBottom, RightBottom: T2DIntRect);
begin
  if Self.Left = Self.Right then
  begin
    LeftTop.Left := Self.Left;
    LeftTop.Right := Self.Right;

    LeftBottom.Left := Self.Left;
    LeftBottom.Right := Self.Right;

    RightTop.Left := Self.Left;
    RightTop.Right := Self.Right;

    RightBottom.Left := Self.Left;
    RightBottom.Right := Self.Right;
  end
  else
  begin
    LeftTop.Left := Self.Left;
    LeftTop.Right := Self.Left + (Self.Right - Self.Left) div 2;

    LeftBottom.Left := Self.Left;
    LeftBottom.Right := Self.Left + (Self.Right - Self.Left) div 2;

    RightTop.Left := Self.Left + (Self.Right - Self.Left) div 2 + 1;
    RightTop.Right := Self.Right;

    RightBottom.Left := Self.Left + (Self.Right - Self.Left) div 2 + 1;
    RightBottom.Right := Self.Right;
  end;

  if Self.Top = Self.Bottom then
  begin
    LeftTop.Top := Self.Top;
    LeftTop.Bottom := Self.Bottom;

    LeftBottom.Top := Self.Top;
    LeftBottom.Bottom := Self.Bottom;

    RightTop.Top := Self.Top;
    RightTop.Bottom := Self.Bottom;

    RightBottom.Top := Self.Top;
    RightBottom.Bottom := Self.Bottom;
  end
  else
  begin
    LeftTop.Top := Self.Top;
    LeftTop.Bottom := Self.Top + (Self.Bottom - Self.Top) div 2;

    LeftBottom.Top := Self.Top;
    LeftBottom.Bottom := Self.Top + (Self.Bottom - Self.Top) div 2;

    RightTop.Top := Self.Top + (Self.Bottom - Self.Top) div 2 + 1;
    RightTop.Bottom := Self.Bottom;

    RightBottom.Top := Self.Top + (Self.Bottom - Self.Top) div 2 + 1;
    RightBottom.Bottom := Self.Bottom;
  end;
end;

class operator T2DIntRect.Subtract(AVector: T2DIntVector; ARect: T2DIntRect): T2DIntRect;
begin
  Result := T2DIntRect.Create(AVector.x - ARect.Left, AVector.y - ARect.Top, AVector.x - ARect.Right, AVector.y - ARect.Bottom);
end;

class operator T2DIntRect.Subtract(ARect: T2DIntRect; AVector: T2DIntVector): T2DIntRect;
begin
  Result := T2DIntRect.Create(ARect.Left - AVector.x, ARect.Top - AVector.y, ARect.Right - AVector.x, ARect.Bottom - AVector.y);
end;

function T2DIntRect.Width: Integer;
begin
  Result := Self.Right - Self.Left + 1;
end;

function T2DIntRect.Moved(dx, dy: Integer): T2DIntRect;
begin
  Result.Left := Self.Left + dx;
  Result.Right := Self.Right + dx;
  Result.Top := Self.Top + dy;
  Result.Bottom := Self.Bottom + dy;
end;

class operator T2DIntRect.Explicit(ARect: T2DIntRect): string;
begin
  Result := '(' + IntToStr(ARect.Left) + ', ' + IntToStr(ARect.Top) + ', ' + IntToStr(ARect.Right) + ', ' + IntToStr(ARect.Bottom) + ')';
end;

function T2DIntRect.ForWinAPI: TRect;
begin
  Result.left := Self.Left;
  Result.Top := Self.Top;
  Result.right := Self.Right + 1;
  Result.Bottom := Self.Bottom + 1;
end;

{ T2DRect }

function T2DRect.Contains(APoint: T2DPoint): boolean;
begin
  Result := (APoint.x >= Self.left) and (APoint.y <= Self.right) and (APoint.y >= Self.Top) and (APoint.y <= Self.Bottom);
end;

constructor T2DRect.Create(ALeft, ATop, ARight, ABottom: extended);
begin
  Self.left := ALeft;
  Self.Top := ATop;
  Self.right := ARight;
  Self.Bottom := ABottom;
end;

constructor T2DRect.Create(ATopLeft, ABottomRight: T2DVector);
begin
  Self.TopLeft := ATopLeft;
  Self.BottomRight := ABottomRight;
end;

class operator T2DRect.Explicit(ARect: TRect): T2DRect;
begin
  Result.left := ARect.left;
  Result.Top := ARect.Top;
  Result.right := ARect.right;
  Result.Bottom := ARect.Bottom;
end;

class operator T2DRect.Explicit(ARect: T2DRect): TRect;
begin
  Result.left := Round(ARect.left);
  Result.Top := Round(ARect.Top);
  Result.right := Round(ARect.right);
  Result.Bottom := Round(ARect.Bottom);
end;

class operator T2DRect.Explicit(ARect: T2DRect): T2DIntRect;
begin
  Result.Left := Round(ARect.left);
  Result.Top := Round(ARect.Top);
  Result.Right := Round(ARect.right);
  Result.Bottom := Round(ARect.Bottom);
end;

procedure T2DRect.ExpandBy(APoint: T2DPoint);
begin
  Self.left := min(Self.left, APoint.x);
  Self.right := max(Self.right, APoint.x);
  Self.Top := min(Self.Top, APoint.y);
  Self.Bottom := max(Self.Bottom, APoint.y);
end;

class operator T2DRect.Explicit(ARect: T2DIntRect): T2DRect;
begin
  Result.left := ARect.Left;
  Result.Top := ARect.Top;
  Result.right := ARect.Right;
  Result.Bottom := ARect.Bottom;
end;

function T2DRect.GetVertex(ACorner: TRectCorner): T2DVector;
begin
  case ACorner of
    rcLeftTop:
      Result := T2DVector.Create(Self.left, Self.Top);
    rcRightTop:
      Result := T2DVector.Create(Self.right, Self.Top);
    rcLeftBottom:
      Result := T2DVector.Create(Self.left, Self.Bottom);
    rcRightBottom:
      Result := T2DVector.Create(Self.right, Self.Bottom);
  end;
end;

function T2DRect.Height: extended;
begin
  Result := Self.Bottom - Self.Top;
end;

class operator T2DRect.Implicit(ARect: TRect): T2DRect;
begin
  Result.left := ARect.left;
  Result.Top := ARect.Top;
  Result.right := ARect.right;
  Result.Bottom := ARect.Bottom;
end;

class operator T2DRect.Implicit(ARect: T2DRect): TRect;
begin
  Result.left := Round(ARect.left);
  Result.Top := Round(ARect.Top);
  Result.right := Round(ARect.right);
  Result.Bottom := Round(ARect.Bottom);
end;

class operator T2DRect.Implicit(ARect: T2DRect): T2DIntRect;
begin
  Result.Left := Round(ARect.left);
  Result.Top := Round(ARect.Top);
  Result.Right := Round(ARect.right);
  Result.Bottom := Round(ARect.Bottom);
end;

class operator T2DRect.Implicit(ARect: T2DIntRect): T2DRect;
begin
  Result.left := ARect.Left;
  Result.Top := ARect.Top;
  Result.right := ARect.Right;
  Result.Bottom := ARect.Bottom;
end;

function T2DRect.IntersectsWith(ARect: T2DRect): boolean;
begin
  Result := (((ARect.left >= Self.left) and (ARect.left <= Self.left)) or ((ARect.right >= Self.right) and (ARect.right <= Self.right)) or
    ((Self.left >= ARect.left) and (Self.left <= ARect.right)) or ((Self.right >= ARect.left) and (Self.right <= ARect.right))) and
    (((ARect.Top >= Self.Top) and (ARect.Top <= Self.Top)) or ((ARect.Bottom >= Self.Bottom) and (ARect.Bottom <= Self.Bottom)) or
    ((Self.Top >= ARect.Top) and (Self.Top <= ARect.Bottom)) or ((Self.Bottom >= ARect.Top) and (Self.Bottom <= ARect.Bottom)));
end;

procedure T2DRect.Move(dx, dy: extended);
begin
  Self.left := Self.left + dx;
  Self.right := Self.right + dx;
  Self.Top := Self.Top + dy;
  Self.Bottom := Self.Bottom + dy;
end;

function T2DRect.Moved(dx, dy: extended): T2DRect;
begin
  Result.left := Self.left + dx;
  Result.right := Self.right + dx;
  Result.Top := Self.Top + dy;
  Result.Bottom := Self.Bottom + dy;
end;

procedure T2DRect.Move(vector: T2DVector);
begin
  Self.left := Self.left + vector.x;
  Self.right := Self.right + vector.x;
  Self.Top := Self.Top + vector.y;
  Self.Bottom := Self.Bottom + vector.y;
end;

function T2DRect.Moved(vector: T2DVector): T2DRect;
begin
  Result.left := Self.left + vector.x;
  Result.right := Self.right + vector.x;
  Result.Top := Self.Top + vector.y;
  Result.Bottom := Self.Bottom + vector.y;
end;

procedure T2DRect.SetCenteredHeight(ANewHeight: extended);
var
  center: extended;
begin
  if (ANewHeight < 0) then
    raise exception.Create('T2DRect.SetCenteredHeight: New height is less than zero!');

  center := Self.Top + (Self.Bottom - Self.Top) / 2;
  Self.Top := center - (ANewHeight / 2);
  Self.Bottom := center + (ANewHeight / 2);
end;

procedure T2DRect.SetCenteredWidth(ANewWidth: extended);
var
  center: extended;
begin
  if (ANewWidth < 0) then
    raise exception.Create('T2DRect.SetCenteredWidth: New width is less than zero!');

  center := Self.left + (Self.right - Self.left) / 2;
  Self.left := center - (ANewWidth / 2);
  Self.right := center + (ANewWidth / 2);
end;

procedure T2DRect.Split(var LeftTop, RightTop, LeftBottom, RightBottom: T2DRect);
begin
  LeftTop.left := Self.left;
  LeftTop.right := Self.left + (Self.right - Self.left) / 2;

  LeftBottom.left := Self.left;
  LeftBottom.right := Self.left + (Self.right - Self.left) / 2;

  RightTop.left := Self.left + (Self.right - Self.left) / 2;
  RightTop.right := Self.right;

  RightBottom.left := Self.left + (Self.right - Self.left) / 2;
  RightBottom.right := Self.right;

  LeftTop.Top := Self.Top;
  LeftTop.Bottom := Self.Top + (Self.Bottom - Self.Top) / 2;

  LeftBottom.Top := Self.Top;
  LeftBottom.Bottom := Self.Top + (Self.Bottom - Self.Top) / 2;

  RightTop.Top := Self.Top + (Self.Bottom - Self.Top) / 2;
  RightTop.Bottom := Self.Bottom;

  RightBottom.Top := Self.Top + (Self.Bottom - Self.Top) / 2;
  RightBottom.Bottom := Self.Bottom;
end;

function T2DRect.Width: extended;
begin
  Result := Self.right - Self.left;
end;

class operator T2DRect.Explicit(ARect: T2DRect): string;
begin
  Result := '(' + FloatToStr(ARect.left) + ', ' + FloatToStr(ARect.Top) + ', ' + FloatToStr(ARect.right) + ', ' + FloatToStr(ARect.Bottom) + ')';
end;

class operator T2DRect.Implicit(ARect: T2DRect): string;
begin
  Result := '(' + FloatToStr(ARect.left) + ', ' + FloatToStr(ARect.Top) + ', ' + FloatToStr(ARect.right) + ', ' + FloatToStr(ARect.Bottom) + ')';
end;

end.

