module AHB_MUX (
    input [31:0]HRDATA_1,HRDATA_2,
    input HRESP_1,HRESP_2,HREADYOUT_1,HREADYOUT_2,MUX_SEL,
    output [31:0]HRDATA,
    output HREADY,HRESP
);
    assign HREADY = (MUX_SEL)? HREADYOUT_1:HREADYOUT_2;
    assign HRESP = (MUX_SEL)? HRESP_1:HRESP_2;
    assign HRDATA = (MUX_SEL)? HRDATA_1:HRDATA_2;
endmodule