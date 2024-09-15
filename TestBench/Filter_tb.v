module Filter_tb ();
    reg [7:0]IN;
    reg clk,rst;
    wire [7:0]Average_out;

    initial begin
        clk = 0;
        forever begin
            #1 clk = ~clk;
        end
    end

    Filter dut (.IN(IN),.clk(clk),.Average_out(Average_out),.rst(rst));

    reg [7:0]input_data[99:0];
    reg [7:0]output_data[99:0];
    integer i;
    initial begin
        $readmemh("input1.txt",input_data);
        $readmemh("output1.txt",output_data);
        rst = 1;
        i = 0;
        @(negedge clk);
        rst = 0;
        repeat(100)begin
            IN = input_data[i];
            check_results(i);
            i=i+1;
        end 
        @(negedge clk);
        @(negedge clk);
        $stop;
    end

    task check_results(input [10:0] i);
    begin
        @(posedge clk);
        if (Average_out != output_data [i-1])
        $display("Error, the expected value is: %h, the output value is: %h", output_data[i], Average_out);
    end
    endtask
endmodule