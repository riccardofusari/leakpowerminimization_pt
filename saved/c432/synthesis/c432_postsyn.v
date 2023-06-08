/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Expert(TM) in wire load mode
// Version   : O-2018.06-SP4
// Date      : Wed Jun  7 01:56:43 2023
/////////////////////////////////////////////////////////////


module c432 ( N1, N4, N8, N11, N14, N17, N21, N24, N27, N30, N34, N37, N40, 
        N43, N47, N50, N53, N56, N60, N63, N66, N69, N73, N76, N79, N82, N86, 
        N89, N92, N95, N99, N102, N105, N108, N112, N115, N223, N329, N370, 
        N421, N430, N431, N432 );
  input N1, N4, N8, N11, N14, N17, N21, N24, N27, N30, N34, N37, N40, N43, N47,
         N50, N53, N56, N60, N63, N66, N69, N73, N76, N79, N82, N86, N89, N92,
         N95, N99, N102, N105, N108, N112, N115;
  output N223, N329, N370, N421, N430, N431, N432;
  wire   n189, n82, n84, n85, n86, n87, n88, n89, n90, n91, n92, n93, n94, n95,
         n96, n97, n98, n99, n100, n101, n102, n103, n104, n105, n106, n107,
         n108, n109, n110, n111, n112, n113, n114, n115, n116, n117, n118,
         n119, n120, n121, n122, n123, n124, n125, n126, n127, n128, n129,
         n130, n131, n132, n133, n134, n135, n136, n137, n138, n139, n140,
         n141, n142, n143, n144, n145, n146, n147, n148, n149, n150, n151,
         n152, n153, n154, n155, n156, n157, n158, n159, n160, n161, n162,
         n163, n164, n165, n166, n167, n168, n169, n170, n171, n172, n173,
         n174, n175, n176, n177, n178, n179, n180, n181, n182, n183, n184,
         n185, n186;

  HS65_LL_NAND2X2 U82 ( .A(N50), .B(N223), .Z(n106) );
  HS65_LL_NAND2X2 U83 ( .A(N76), .B(N223), .Z(n105) );
  HS65_LL_IVX2 U85 ( .A(n148), .Z(n149) );
  HS65_LL_NAND2X2 U86 ( .A(n116), .B(n148), .Z(n146) );
  HS65_LL_IVX22 U87 ( .A(n189), .Z(N421) );
  HS65_LL_NOR2X3 U88 ( .A(n166), .B(n172), .Z(n167) );
  HS65_LL_NAND3X6 U89 ( .A(n147), .B(n146), .C(n145), .Z(n163) );
  HS65_LL_CBI4I1X5 U91 ( .A(N30), .B(n162), .C(n152), .D(n151), .Z(n153) );
  HS65_LL_NAND2X4 U92 ( .A(n131), .B(n130), .Z(n143) );
  HS65_LL_NAND2X4 U93 ( .A(n100), .B(n113), .Z(n102) );
  HS65_LL_NAND2X2 U94 ( .A(n150), .B(N223), .Z(n103) );
  HS65_LL_AOI12X6 U95 ( .A(N37), .B(N223), .C(n101), .Z(n157) );
  HS65_LL_NAND2X4 U96 ( .A(n164), .B(N223), .Z(n96) );
  HS65_LL_NAND2X4 U97 ( .A(N102), .B(N223), .Z(n97) );
  HS65_LL_OR3ABCX35 U98 ( .A(n95), .B(n94), .C(n93), .Z(N223) );
  HS65_LL_AOI22X4 U99 ( .A(N108), .B(n85), .C(N82), .D(n84), .Z(n95) );
  HS65_LL_IVX2 U100 ( .A(N63), .Z(n86) );
  HS65_LL_CB4I6X9 U101 ( .A(n172), .B(n171), .C(n170), .D(n169), .Z(n189) );
  HS65_LL_NOR4ABX4 U102 ( .A(n179), .B(n175), .C(N108), .D(N430), .Z(n169) );
  HS65_LL_AOI211X4 U103 ( .A(N86), .B(N329), .C(n168), .D(n167), .Z(n178) );
  HS65_LL_BFX27 U105 ( .A(n112), .Z(N329) );
  HS65_LL_NOR2X5 U106 ( .A(N73), .B(n132), .Z(n128) );
  HS65_LL_NOR2X5 U107 ( .A(N112), .B(n136), .Z(n127) );
  HS65_LL_NOR2X5 U108 ( .A(N34), .B(n133), .Z(n120) );
  HS65_LL_NOR2X5 U109 ( .A(N99), .B(n159), .Z(n119) );
  HS65_LL_NAND2AX7 U110 ( .A(n107), .B(n106), .Z(n154) );
  HS65_LL_AOI12X6 U111 ( .A(N1), .B(N223), .C(n99), .Z(n113) );
  HS65_LL_AOI21X4 U112 ( .A(N95), .B(n89), .C(n88), .Z(n94) );
  HS65_LL_NOR2X5 U113 ( .A(n92), .B(n91), .Z(n93) );
  HS65_LL_IVX7 U114 ( .A(N4), .Z(n99) );
  HS65_LL_IVX2 U115 ( .A(N76), .Z(n84) );
  HS65_LL_IVX2 U116 ( .A(N102), .Z(n85) );
  HS65_LL_IVX2 U117 ( .A(N89), .Z(n89) );
  HS65_LL_OR2X18 U118 ( .A(n82), .B(n184), .Z(N432) );
  HS65_LL_IVX4 U119 ( .A(n173), .Z(n176) );
  HS65_LL_AOI12X4 U120 ( .A(N66), .B(n163), .C(n155), .Z(n177) );
  HS65_LL_AOI12X6 U121 ( .A(N40), .B(n163), .C(n153), .Z(n186) );
  HS65_LL_NAND2X4 U122 ( .A(n157), .B(n156), .Z(n158) );
  HS65_LL_AOI12X6 U123 ( .A(N8), .B(N329), .C(n114), .Z(n170) );
  HS65_LL_OAI211X3 U125 ( .A(N53), .B(n124), .C(n123), .D(n122), .Z(n144) );
  HS65_LL_NOR2X5 U126 ( .A(N60), .B(n154), .Z(n117) );
  HS65_LL_NAND2X4 U127 ( .A(N108), .B(n97), .Z(n136) );
  HS65_LL_NAND2X4 U128 ( .A(N69), .B(n96), .Z(n132) );
  HS65_LL_NAND2X4 U129 ( .A(N30), .B(n103), .Z(n133) );
  HS65_LL_NAND2X7 U130 ( .A(N17), .B(n98), .Z(n115) );
  HS65_LL_IVX4 U131 ( .A(n113), .Z(n114) );
  HS65_LL_NAND2X4 U133 ( .A(n164), .B(n150), .Z(n88) );
  HS65_LL_OAI22X3 U134 ( .A(N11), .B(n90), .C(N1), .D(n99), .Z(n92) );
  HS65_LL_OAI22X3 U135 ( .A(N37), .B(n101), .C(N50), .D(n107), .Z(n91) );
  HS65_LL_IVX4 U136 ( .A(N43), .Z(n101) );
  HS65_LL_IVX4 U137 ( .A(N56), .Z(n107) );
  HS65_LL_IVX2 U138 ( .A(N17), .Z(n90) );
  HS65_LL_IVX4 U139 ( .A(N24), .Z(n87) );
  HS65_LL_IVX4 U140 ( .A(N14), .Z(n171) );
  HS65_LL_NOR2X5 U141 ( .A(n186), .B(n185), .Z(n82) );
  HS65_LL_NAND2X14 U143 ( .A(n174), .B(n173), .Z(N430) );
  HS65_LL_NOR2X6 U144 ( .A(n184), .B(n186), .Z(n174) );
  HS65_LL_OAI12X3 U145 ( .A(n161), .B(n172), .C(n160), .Z(n179) );
  HS65_LL_AOI12X6 U146 ( .A(N27), .B(n163), .C(n149), .Z(n184) );
  HS65_LL_AOI12X4 U147 ( .A(N53), .B(n163), .C(n158), .Z(n181) );
  HS65_LL_IVX7 U148 ( .A(n163), .Z(n172) );
  HS65_LL_AOI12X6 U149 ( .A(N21), .B(N329), .C(n115), .Z(n148) );
  HS65_LL_AOI21X2 U150 ( .A(n141), .B(n140), .C(N329), .Z(n142) );
  HS65_LL_OR2X4 U153 ( .A(n128), .B(n127), .Z(n111) );
  HS65_LL_NOR2X5 U154 ( .A(n120), .B(n119), .Z(n109) );
  HS65_LL_NOR2X5 U155 ( .A(n125), .B(n117), .Z(n108) );
  HS65_LL_NOR2X5 U156 ( .A(N86), .B(n168), .Z(n125) );
  HS65_LL_OAI211X4 U157 ( .A(N21), .B(n115), .C(n102), .D(n124), .Z(n110) );
  HS65_LL_NAND2X5 U158 ( .A(N82), .B(n105), .Z(n168) );
  HS65_LL_NAND2X5 U159 ( .A(N95), .B(n104), .Z(n159) );
  HS65_LL_NAND2X5 U160 ( .A(N11), .B(N223), .Z(n98) );
  HS65_LL_NAND2X5 U161 ( .A(N30), .B(n87), .Z(n150) );
  HS65_LL_NAND2X5 U162 ( .A(N69), .B(n86), .Z(n164) );
  HS65_LL_AO12X4 U163 ( .A(N60), .B(N329), .C(n154), .Z(n155) );
  HS65_LL_NAND2X2 U164 ( .A(N69), .B(n162), .Z(n165) );
  HS65_LL_IVX2 U165 ( .A(n150), .Z(n152) );
  HS65_LL_OAI22X1 U166 ( .A(N40), .B(n133), .C(N79), .D(n132), .Z(n134) );
  HS65_LL_IVX2 U167 ( .A(N79), .Z(n129) );
  HS65_LL_IVX2 U168 ( .A(N40), .Z(n121) );
  HS65_LL_IVX2 U169 ( .A(N27), .Z(n116) );
  HS65_LL_IVX2 U170 ( .A(n159), .Z(n135) );
  HS65_LL_AOI22X1 U171 ( .A(n129), .B(n128), .C(n127), .D(n126), .Z(n130) );
  HS65_LL_NAND2X2 U172 ( .A(n166), .B(n125), .Z(n131) );
  HS65_LL_IVX2 U173 ( .A(N115), .Z(n126) );
  HS65_LL_NAND2X2 U174 ( .A(n118), .B(n117), .Z(n123) );
  HS65_LL_AOI22X1 U175 ( .A(n121), .B(n120), .C(n119), .D(n161), .Z(n122) );
  HS65_LL_IVX2 U176 ( .A(N66), .Z(n118) );
  HS65_LL_IVX2 U177 ( .A(n177), .Z(n182) );
  HS65_LL_NAND2AX4 U178 ( .A(N47), .B(n157), .Z(n124) );
  HS65_LL_IVX2 U179 ( .A(N8), .Z(n100) );
  HS65_LL_OAI12X24 U180 ( .A(n176), .B(n175), .C(n174), .Z(N431) );
  HS65_LL_OAI22X1 U181 ( .A(N66), .B(n154), .C(N115), .D(n136), .Z(n137) );
  HS65_LL_IVX2 U182 ( .A(N53), .Z(n139) );
  HS65_LL_IVX2 U183 ( .A(N92), .Z(n166) );
  HS65_LL_IVX2 U184 ( .A(N223), .Z(n162) );
  HS65_LL_IVX2 U185 ( .A(N105), .Z(n161) );
  HS65_LL_NOR2X2 U186 ( .A(n179), .B(n178), .Z(n180) );
  HS65_LL_NOR2AX3 U187 ( .A(n166), .B(n168), .Z(n138) );
  HS65_LL_NOR3X4 U188 ( .A(n144), .B(n143), .C(n142), .Z(n145) );
  HS65_LL_BFX13 U189 ( .A(n163), .Z(N370) );
  HS65_LL_NOR2X6 U190 ( .A(n177), .B(n181), .Z(n173) );
  HS65_LL_AOI12X2 U191 ( .A(N99), .B(N329), .C(n159), .Z(n160) );
  HS65_LL_AOI222X2 U192 ( .A(n165), .B(n164), .C(N329), .D(N73), .E(n163), .F(
        N79), .Z(n183) );
  HS65_LL_NOR2X6 U193 ( .A(n183), .B(n178), .Z(n175) );
  HS65_LL_NAND2X2 U84 ( .A(N89), .B(N223), .Z(n104) );
  HS65_LL_NAND2X2 U90 ( .A(N47), .B(N329), .Z(n156) );
  HS65_LL_AOI112X1 U124 ( .A(n157), .B(n139), .C(n138), .D(n137), .Z(n140) );
  HS65_LL_AOI112X1 U132 ( .A(n183), .B(n182), .C(n181), .D(n180), .Z(n185) );
  HS65_LL_NAND2X2 U142 ( .A(n171), .B(n170), .Z(n147) );
  HS65_LL_NAND4ABX6 U151 ( .A(n111), .B(n110), .C(n109), .D(n108), .Z(n112) );
  HS65_LL_NAND2X2 U104 ( .A(N34), .B(N329), .Z(n151) );
  HS65_LL_AOI12X2 U152 ( .A(n135), .B(n161), .C(n134), .Z(n141) );
endmodule

