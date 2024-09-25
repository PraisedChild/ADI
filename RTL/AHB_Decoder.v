module AHB_Decoder (
    input HADDR,
    output HSEL_1,HSEL_2,MUX_SEL
);
    assign HSEL_1 = HADDR;
    assign HSEL_2 = ~HADDR;
    assign MUX_SEL = ~HADDR;
endmodule