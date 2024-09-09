# SEQUENCE DETECTOR REPORT
Owner: Abdelrahman Akram Ibrahim Aly

## Project Inspiration
When two blocks try to communicate over a noisy channel, the simple usage of an enable signal or a data_valid signal could cause problems as that singular signal itself could be misread. Therefore for the establishment of connection we instead use a Sequence of inputs that when read by the Receiver it is able to identify them and raise the receive flag to enable communication.

## Blocks Summary
### PRBS
- LFSR : A 15 bit shift register that is synchronously set with a seed originated from the first 15 bit of the input, used to generate a random output by XORing the 2 least significant bits and outputting them with another 7 bits from the shift register.
- Sequencer : Responsible for sending the correct sequence to the receiving unit to ensure the establishment of connection before the receiving unit can raise its flag.
- Control Unit: A FSM that sends control signals to both the LFSR and the Sequencer as well as the MUX to ensure correct operation, it is triggered by raising the data_valid flag in its input.

### RECEIVER
- A single block that receives data from the PRBS and only establishes connection once a specific sequence has been noticed using an FSM, once the sequence has been detected a receive_flag is raised and random data is received.

## CODE

### Receiver
```
module Receiver #(
    parameter SEQUENCE = 32'habcdefab
)(
    input [7:0]n,in,
    input clk,rst,
    output reg receive_flag
);
    typedef enum bit [3:0] {
        S0 = 4'b0001,
        S1 = 4'b0010,
        S2 = 4'b0100,
        S3 = 4'b1000
    } state_e;

    state_e cs,ns;
    reg [9:0] counter;
    reg counter_flag,counter_hold;

    always@(posedge clk or posedge rst)begin
        if(rst)
        cs<=S0;
        else
        cs<=ns;
    end

    always@(posedge clk or posedge rst)begin
        if(rst)
        counter<=0;
        else begin
            if(!counter_hold)begin
            if(counter_flag)
            counter<= counter+1;
            else
            counter<=0;
        end
        end
    end
    always@(*)begin
        if((counter==(n*4)))begin
            ns = S0;
            receive_flag = 1;
            counter_flag = 1;
            counter_hold = 1;
        end
        else begin
            receive_flag = 0;
            counter_hold = 0;
        case(cs)
        S0: if(in==8'hab) begin
                ns = S1;
                counter_flag = 1;
            end
            else begin
                ns = S0;
                counter_flag = 0;
            end
        S1: if(in==8'hcd) begin
                ns = S2;
                counter_flag = 1;
            end
            else begin
                ns = S0;
                counter_flag = 0;
            end
        S2: if(in==8'hef) begin
                ns = S3;
                counter_flag = 1;
            end
            else begin
                ns = S0;
                counter_flag = 0;
            end
        S3: if(in==8'hab)begin
                ns = S0;
                counter_flag = 1;
            end
            else begin
                ns = S0;
                counter_flag = 0;
            end
        default: begin
            ns = S0;
            counter_flag = 0;
            end
        endcase
    end
    end
endmodule
```

### LFSR
```
module LFSR (
    input block_enable,clk,rst,
    input [14:0]seed,
    output reg [7:0]out_rand
);

    reg [14:0] shift_reg;

    always@(posedge clk)begin
        if(rst)begin
            shift_reg <= seed;
            out_rand<= 8'b0000_0000;
        end
        else begin
            if(block_enable)begin
                shift_reg[14]<=shift_reg[13];
                shift_reg[13]<=shift_reg[12];
                shift_reg[12]<=shift_reg[11];
                shift_reg[11]<=shift_reg[10];
                shift_reg[10]<=shift_reg[9];
                shift_reg[9]<=shift_reg[8];
                shift_reg[8]<=shift_reg[7];
                shift_reg[7]<=shift_reg[6];
                shift_reg[6]<=shift_reg[5];
                shift_reg[5]<=shift_reg[4];
                shift_reg[4]<=shift_reg[3];
                shift_reg[3]<=shift_reg[2];
                shift_reg[2]<=shift_reg[1];
                shift_reg[1]<=shift_reg[0];
                shift_reg[0]<=shift_reg[14];
                out_rand<={shift_reg[0]^shift_reg[1],shift_reg[11:5]};
            end
        end
    end
endmodule
```

### Sequencer
```
module Sequencer (
    input clk,Seq_en,rst,
    input [7:0]n,
    input [31:0]in,
    output reg Seq_done,
    output reg [7:0] Sequence
);

    reg [1:0] counter;
    reg [7:0] n_counter;

    always@(posedge clk or posedge rst)begin
        if(rst)begin
            counter<=0;
            n_counter<=0;
            Seq_done<=0;
            Sequence<=0;
        end
        else begin
            if(Seq_en)begin
                Seq_done<=0;
                if(n_counter==n)begin
                    Seq_done<=1;
                end
                else begin
                case(counter)
                0: begin
                    Sequence<=in[31:24];
                    counter<=1;
                end
                1: begin
                    Sequence<=in[23:16];
                    counter<=2;
                end
                2: begin
                    Sequence<=in[15:8];
                    counter<=3;
                end
                3: begin
                    Sequence<=in[7:0];
                    counter<=0;
                    n_counter<=n_counter+1;
                end
                default: Sequence<=8'b0000_0000;
                endcase
                end
            end
        end
    end
endmodule
```

### Control Unit
```
module Control_Unit (
    input [31:0] in,
    input [7:0] n,
    input clk,rst,seq_done,data_valid,
    output reg seq_enable,
    output reg rand_flag,
    output [7:0] seq_num,
    output [31:0] seq_data
);
    ///this block doesn't use out valid, but instead uses a sequence of patterns for the other block to recognize 
    ///that transmission is about to begin, this is useful for noisy environments.

    typedef enum bit [2:0] { 
        IDLE = 3'b001,
        ESTABLISHMENT = 3'b010,
        RANDOMIZATION = 3'b100
    } state_e;
    
    ///fsm, got state of idle, establishment, and randomization, onehot encoding for performance.

    state_e cs,ns;

    ///state block///
    always@(posedge clk or posedge rst)begin
        if(rst)begin
            cs<=IDLE;
        end
        else begin
            cs<=ns;
        end
    end

    ///next state logic & outputs///
    always@(*)begin
        rand_flag = 0;
        seq_enable=0;
        case(cs)
        IDLE:begin
            if(data_valid) begin
                ns=ESTABLISHMENT;
                seq_enable=1;
            end
            else
                ns=IDLE;
                seq_enable=0;
            end
        ESTABLISHMENT: begin
            if(seq_done) begin
            ns=RANDOMIZATION;
            seq_enable=0;
            end
            else begin
            ns=ESTABLISHMENT;
            seq_enable=1;
            end
        end
        RANDOMIZATION: begin
            ns=RANDOMIZATION;
            rand_flag = 1;
            seq_enable = 0;
        end
        default: begin
            ns = IDLE;
            rand_flag = 0;
            seq_enable=0;
        end
        endcase
    end

    assign seq_data = in;
    assign seq_num = n; 
endmodule
```

### PRBS Wrapper

```
module PRBS (
    input clk,rst,data_valid,
    input [31:0] in,
    input [7:0] n,
    output [7:0]PRBS_OUT
);

    wire mux_sel,sequence_enable,sequence_done;
    wire [31:0] sequence_data;
    wire [7:0] out_est,out_rand,sequence_num;

    MUX2 mux0 (.mux_sel(mux_sel),.in_est(out_est),.in_rand(out_rand),.out(PRBS_OUT));
    LFSR lfsr0 (.clk(clk),.rst(rst),.seed(in[14:0]),.block_enable(mux_sel),.out_rand(out_rand));
    Sequencer seq0 (.clk(clk),.rst(rst),.Seq_en(sequence_enable),.in(sequence_data),.n(sequence_num),.Seq_done(sequence_done),.Sequence(out_est));
    Control_Unit CU0 (.clk(clk),.rst(rst),.in(in),.n(n),.data_valid(data_valid),.seq_enable(sequence_enable),.seq_done(sequence_done),.rand_flag(mux_sel), .seq_data(sequence_data),.seq_num(sequence_num));
endmodule
```

### Complete Design Wrap

```
module Wrapper (
    input clk,rst,data_valid,
    input [31:0] in,
    input [7:0] n,
    output receive_flag
);
    wire [7:0]prbs_out;
    PRBS prbs (.clk(clk),.rst(rst),.data_valid(data_valid),.in(in),.n(n),.PRBS_OUT(prbs_out));
    Receiver rcv (.clk(clk),.rst(rst),.in(prbs_out),.n(n),.receive_flag(receive_flag));
    
endmodule
```

## TestBenches

- The testbenches are available in the repositry but will not be included in this document to not result in extreme redundancy of code.


