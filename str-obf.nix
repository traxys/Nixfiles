lib:
let
  encodeTable = {
    a = "h";
    b = "g";
    c = "z";
    d = "m";
    e = "l";
    f = "j";
    g = "v";
    h = "a";
    i = "n";
    j = "t";
    k = "w";
    l = "b";
    m = "y";
    n = "x";
    o = "i";
    p = "q";
    q = "o";
    r = "f";
    s = "d";
    t = "s";
    u = "r";
    v = "e";
    w = "k";
    x = "c";
    y = "p";
    z = "u";
  };
  decodeTable = {
    h = "a";
    g = "b";
    z = "c";
    m = "d";
    l = "e";
    j = "f";
    v = "g";
    a = "h";
    n = "i";
    t = "j";
    w = "k";
    b = "l";
    y = "m";
    x = "n";
    i = "o";
    q = "p";
    o = "q";
    f = "r";
    d = "s";
    s = "t";
    r = "u";
    e = "v";
    k = "w";
    c = "x";
    p = "y";
    u = "z";
  };
in
{
  encode = lib.stringAsChars (x: encodeTable.${x} or x);
  decode = lib.stringAsChars (x: decodeTable.${x} or x);
}
