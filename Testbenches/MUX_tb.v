module MUX_tb ();
    
    reg mux_sel; 
    reg [7:0] in_est, in_rand;
    wire [7:0]out;
    reg clk;

    initial begin
        clk = 0;
        forever begin
            #1 clk = ~clk;
        end
    end

    MUX2 dut (.mux_sel(mux_sel),.in_est(in_est),.in_rand(in_rand),.out(out));

    initial begin
        repeat(10)begin
            mux_sel = $random;
            in_est = $random;
            in_rand = $random;
            @(negedge clk);
        end
        $stop;
    end 
endmodule