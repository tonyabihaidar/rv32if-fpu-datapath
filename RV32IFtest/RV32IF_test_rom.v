`include "archerdefs.v"

module rom (
    input [`ADDRLEN-1:0] addr,
    output [`XLEN-1:0] dataout
);

    integer i;
    reg [7:0] rom_array [0:(2**(`ADDRLEN))-1];
    wire [(`ADDRLEN-1):0] word_addr;

    assign word_addr = {addr[(`ADDRLEN-1):2], 2'b00};
    assign dataout = {rom_array[word_addr+3], rom_array[word_addr+2], rom_array[word_addr+1], rom_array[word_addr]};

    initial 
    begin

    rom_array[0] = 8'hB3;
    rom_array[1] = 8'h02;
    rom_array[2] = 8'h00;
    rom_array[3] = 8'h00;
    
    rom_array[4] = 8'h13;
    rom_array[5] = 8'h03;
    rom_array[6] = 8'hB0;
    rom_array[7] = 8'h00;
    
    rom_array[8] = 8'h97;
    rom_array[9] = 8'h03;
    rom_array[10] = 8'h00;
    rom_array[11] = 8'h10;
    
    rom_array[12] = 8'h93;
    rom_array[13] = 8'h83;
    rom_array[14] = 8'h83;
    rom_array[15] = 8'hFF;
    
    rom_array[16] = 8'h63;
    rom_array[17] = 8'hDE;
    rom_array[18] = 8'h62;
    rom_array[19] = 8'h00;
    
    rom_array[20] = 8'h13;
    rom_array[21] = 8'h85;
    rom_array[22] = 8'h02;
    rom_array[23] = 8'h00;
    
    rom_array[24] = 8'hEF;
    rom_array[25] = 8'h00;
    rom_array[26] = 8'hC0;
    rom_array[27] = 8'h01;
    
    rom_array[28] = 8'h23;
    rom_array[29] = 8'hA0;
    rom_array[30] = 8'hA3;
    rom_array[31] = 8'h00;
    
    rom_array[32] = 8'h93;
    rom_array[33] = 8'h83;
    rom_array[34] = 8'h43;
    rom_array[35] = 8'h00;
    
    rom_array[36] = 8'h93;
    rom_array[37] = 8'h82;
    rom_array[38] = 8'h12;
    rom_array[39] = 8'h00;
    
    rom_array[40] = 8'h6F;
    rom_array[41] = 8'hF0;
    rom_array[42] = 8'h9F;
    rom_array[43] = 8'hFE;
    
    rom_array[44] = 8'h13;
    rom_array[45] = 8'h05;
    rom_array[46] = 8'hA0;
    rom_array[47] = 8'h00;
    
    rom_array[48] = 8'h73;
    rom_array[49] = 8'h00;
    rom_array[50] = 8'h00;
    rom_array[51] = 8'h00;
    
    rom_array[52] = 8'h13;
    rom_array[53] = 8'h01;
    rom_array[54] = 8'h41;
    rom_array[55] = 8'hFF;
    
    rom_array[56] = 8'h23;
    rom_array[57] = 8'h20;
    rom_array[58] = 8'h11;
    rom_array[59] = 8'h00;
    
    rom_array[60] = 8'h23;
    rom_array[61] = 8'h22;
    rom_array[62] = 8'hA1;
    rom_array[63] = 8'h00;
    
    rom_array[64] = 8'h13;
    rom_array[65] = 8'h0E;
    rom_array[66] = 8'h10;
    rom_array[67] = 8'h00;
    
    rom_array[68] = 8'h63;
    rom_array[69] = 8'h44;
    rom_array[70] = 8'hAE;
    rom_array[71] = 8'h00;
    
    rom_array[72] = 8'h6F;
    rom_array[73] = 8'h00;
    rom_array[74] = 8'h40;
    rom_array[75] = 8'h02;
    
    rom_array[76] = 8'h13;
    rom_array[77] = 8'h05;
    rom_array[78] = 8'hF5;
    rom_array[79] = 8'hFF;
    
    rom_array[80] = 8'hEF;
    rom_array[81] = 8'hF0;
    rom_array[82] = 8'h5F;
    rom_array[83] = 8'hFE;
    
    rom_array[84] = 8'h23;
    rom_array[85] = 8'h24;
    rom_array[86] = 8'hA1;
    rom_array[87] = 8'h00;
    
    rom_array[88] = 8'h03;
    rom_array[89] = 8'h25;
    rom_array[90] = 8'h41;
    rom_array[91] = 8'h00;
    
    rom_array[92] = 8'h13;
    rom_array[93] = 8'h05;
    rom_array[94] = 8'hE5;
    rom_array[95] = 8'hFF;
    
    rom_array[96] = 8'hEF;
    rom_array[97] = 8'hF0;
    rom_array[98] = 8'h5F;
    rom_array[99] = 8'hFD;
    
    rom_array[100] = 8'h83;
    rom_array[101] = 8'h25;
    rom_array[102] = 8'h81;
    rom_array[103] = 8'h00;
    
    rom_array[104] = 8'h33;
    rom_array[105] = 8'h05;
    rom_array[106] = 8'hB5;
    rom_array[107] = 8'h00;
    
    rom_array[108] = 8'h83;
    rom_array[109] = 8'h20;
    rom_array[110] = 8'h01;
    rom_array[111] = 8'h00;
    
    rom_array[112] = 8'h13;
    rom_array[113] = 8'h01;
    rom_array[114] = 8'hC1;
    rom_array[115] = 8'h00;
    
    rom_array[116] = 8'h67;
    rom_array[117] = 8'h80;
    rom_array[118] = 8'h00;
    rom_array[119] = 8'h00;

    // Jump to address 0x100 to start floating-point program
        rom_array[120] = 8'h6F; rom_array[121] = 8'h00; rom_array[122] = 8'h10; rom_array[123] = 8'h00; // JAL x0, 0x100

    // Padding up to address 0x100 (256 bytes)
    for (i = 124; i < 256; i = i + 1) begin
        rom_array[i] = 8'h00;
    end

    rom_array[256] = 8'h17; 
    rom_array[257] = 8'h05; 
    rom_array[258] = 8'h01; 
    rom_array[259] = 8'h00;

    rom_array[260] = 8'h13; 
    rom_array[261] = 8'h05; 
    rom_array[262] = 8'h05; 
    rom_array[263] = 8'h00;
    
    rom_array[264] = 8'h87; rom_array[265] = 8'h20; rom_array[266] = 8'h05; rom_array[267] = 8'h00;
    rom_array[268] = 8'h97; rom_array[269] = 8'h05; rom_array[270] = 8'h01; rom_array[271] = 8'h00;
    rom_array[272] = 8'h93; rom_array[273] = 8'h85; rom_array[274] = 8'h85; rom_array[275] = 8'hFF;
    rom_array[276] = 8'h07; rom_array[277] = 8'hA1; rom_array[278] = 8'h05; rom_array[279] = 8'h00;
    rom_array[280] = 8'h17; rom_array[281] = 8'h06; rom_array[282] = 8'h01; rom_array[283] = 8'h00;
    rom_array[284] = 8'h13; rom_array[285] = 8'h06; rom_array[286] = 8'h06; rom_array[287] = 8'hFF;
    rom_array[288] = 8'h87; rom_array[289] = 8'h21; rom_array[290] = 8'h06; rom_array[291] = 8'h00;
    rom_array[292] = 8'h53; rom_array[293] = 8'hF2; rom_array[294] = 8'h20; rom_array[295] = 8'h00;
    rom_array[296] = 8'hD3; rom_array[297] = 8'hF2; rom_array[298] = 8'h20; rom_array[299] = 8'h08;
    rom_array[300] = 8'h53; rom_array[301] = 8'hF3; rom_array[302] = 8'h20; rom_array[303] = 8'h10;
    rom_array[304] = 8'hD3; rom_array[305] = 8'h83; rom_array[306] = 8'h20; rom_array[307] = 8'h28;
    rom_array[308] = 8'h53; rom_array[309] = 8'h94; rom_array[310] = 8'h20; rom_array[311] = 8'h28;
    rom_array[312] = 8'h53; rom_array[313] = 8'hA6; rom_array[314] = 8'h30; rom_array[315] = 8'hA0;
    rom_array[316] = 8'hD3; rom_array[317] = 8'h96; rom_array[318] = 8'h30; rom_array[319] = 8'hA0;
    rom_array[320] = 8'h53; rom_array[321] = 8'h87; rom_array[322] = 8'h31; rom_array[323] = 8'hA0;
    rom_array[324] = 8'h97; rom_array[325] = 8'h05; rom_array[326] = 8'h01; rom_array[327] = 8'h00;
    rom_array[328] = 8'h93; rom_array[329] = 8'h85; rom_array[330] = 8'h85; rom_array[331] = 8'hFC;
    rom_array[332] = 8'h27; rom_array[333] = 8'hA0; rom_array[334] = 8'h45; rom_array[335] = 8'h00;
    rom_array[336] = 8'h87; rom_array[337] = 8'hA9; rom_array[338] = 8'h05; rom_array[339] = 8'h00;
    rom_array[340] = 8'h17; rom_array[341] = 8'h05; rom_array[342] = 8'h01; rom_array[343] = 8'h00;
    rom_array[344] = 8'h13; rom_array[345] = 8'h05; rom_array[346] = 8'hC5; rom_array[347] = 8'hFB;
    rom_array[348] = 8'h87; rom_array[349] = 8'h24; rom_array[350] = 8'h05; rom_array[351] = 8'h00;
    rom_array[352] = 8'h17; rom_array[353] = 8'h05; rom_array[354] = 8'h01; rom_array[355] = 8'h00;
    rom_array[356] = 8'h13; rom_array[357] = 8'h05; rom_array[358] = 8'h45; rom_array[359] = 8'hFB;
    rom_array[360] = 8'h07; rom_array[361] = 8'h25; rom_array[362] = 8'h05; rom_array[363] = 8'h00;
    rom_array[364] = 8'h17; rom_array[365] = 8'h05; rom_array[366] = 8'h01; rom_array[367] = 8'h00;
    rom_array[368] = 8'h13; rom_array[369] = 8'h05; rom_array[370] = 8'hC5; rom_array[371] = 8'hFA;
    rom_array[372] = 8'h87; rom_array[373] = 8'h25; rom_array[374] = 8'h05; rom_array[375] = 8'h00;
    rom_array[376] = 8'h17; rom_array[377] = 8'h05; rom_array[378] = 8'h01; rom_array[379] = 8'h00;
    rom_array[380] = 8'h13; rom_array[381] = 8'h05; rom_array[382] = 8'h45; rom_array[383] = 8'hFA;
    rom_array[384] = 8'h07; rom_array[385] = 8'h26; rom_array[386] = 8'h05; rom_array[387] = 8'h00;
    rom_array[388] = 8'h17; rom_array[389] = 8'h05; rom_array[390] = 8'h01; rom_array[391] = 8'h00;
    rom_array[392] = 8'h13; rom_array[393] = 8'h05; rom_array[394] = 8'hC5; rom_array[395] = 8'hF9;
    rom_array[396] = 8'h87; rom_array[397] = 8'h26; rom_array[398] = 8'h05; rom_array[399] = 8'h00;
    rom_array[400] = 8'hD3; rom_array[401] = 8'hA7; rom_array[402] = 8'h94; rom_array[403] = 8'hA0;
    rom_array[404] = 8'h53; rom_array[405] = 8'h98; rom_array[406] = 8'h14; rom_array[407] = 8'hA0;
    rom_array[408] = 8'hD3; rom_array[409] = 8'h88; rom_array[410] = 8'h14; rom_array[411] = 8'hA0;
    rom_array[412] = 8'h53; rom_array[413] = 8'h85; rom_array[414] = 8'hB5; rom_array[415] = 8'h28;
    rom_array[416] = 8'hD3; rom_array[417] = 8'h8D; rom_array[418] = 8'hB5; rom_array[419] = 8'h28;
    rom_array[420] = 8'hD3; rom_array[421] = 8'h25; rom_array[422] = 8'hD6; rom_array[423] = 8'hA0;
    rom_array[424] = 8'h53; rom_array[425] = 8'h96; rom_array[426] = 8'hC6; rom_array[427] = 8'hA0;
    rom_array[428] = 8'hD3; rom_array[429] = 8'h86; rom_array[430] = 8'hC6; rom_array[431] = 8'hA0;
    rom_array[432] = 8'h93; rom_array[433] = 8'h08; rom_array[434] = 8'hA0; rom_array[435] = 8'h00;
    rom_array[436] = 8'h73; rom_array[437] = 8'h00; rom_array[438] = 8'h00; rom_array[439] = 8'h00;

    // Fill the rest with zeros
    for (i = 440; i < 2**(`ADDRLEN); i = i + 1) begin
        rom_array[i] = 8'h00;
    end
end

endmodule
