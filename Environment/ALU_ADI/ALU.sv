module ALU (clk, rst, A, B, opcode, out);

typedef enum bit [1:0] {ADD, SUB, MULT, DIV} opcode_e;

input bit clk;
input logic rst;
input logic A,B;
input opcode_e opcode;
output logic [1:0] out;


reg [1:0] opcode_reg;
reg A_reg, B_reg;

assign A = aluif.A;
assign B = aluif.B;
assign opcode = aluif.opcode;
assign clk = aluif.clk;
assign rst = aluif.rst;
assign aluif.out = out;

always @(posedge clk or posedge rst) begin
  if(rst) begin
    out <= 0;
    opcode_reg <= 0;
    A_reg <= 0;
    B_reg <= 0;
  end
  else begin
    opcode_reg <= opcode;
    A_reg <= A;
    B_reg <= B;
    case (opcode)
    ADD: out= A_reg + B_reg;

    SUB: out= A_reg - B_reg;

    MULT: out= A_reg * B_reg;

    DIV: begin If(!B_reg && !A_reg)begin
        out = 0;
    end
    else if (!B_reg || !A_reg)
        out = 0 ;
    else out= A_reg / B_reg;
    end

    endcase
  end
endmodule