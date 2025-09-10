`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/29/2024 01:12:22 AM
// Design Name: 
// Module Name: tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////



module mesi_tb;
    // Inputs
    reg clk;
    reg reset;
    reg read;
    reg write;
    reg snoop_read;
    reg snoop_write;
    reg shared;
    reg exclusive;

    // Outputs
    wire [1:0] state;
    wire read_cache_line;
    wire broadcast_invalidate;
    wire write_cache_line_to_memory;
    wire invalidate_cache_line;
    wire write_cache_line;

    // Instantiate the Unit Under Test (UUT)
    mesi uut (
        .clk(clk),
        .reset(reset),
        .read(read),
        .write(write),
        .snoop_read(snoop_read),
        .snoop_write(snoop_write),
        .shared(shared),
        .exclusive(exclusive),
        .state(state),
        .read_cache_line(read_cache_line),
        .broadcast_invalidate(broadcast_invalidate),
        .write_cache_line_to_memory(write_cache_line_to_memory),
        .invalidate_cache_line(invalidate_cache_line),
        .write_cache_line(write_cache_line)
    );

    // Clock generation
    always #5 clk = ~clk;

    // Testbench stimulus
    initial begin
        // Initialize inputs
        clk = 1;
        reset = 1;
        read = 0;
        write = 0;
        snoop_read = 0;
        snoop_write = 0;
        shared = 0;
        exclusive = 0;

        // Apply reset
        #10 reset = 0;

        // Start from Invalid state (I)

        #10;

        // Transition to Shared state (S)
        read = 1; shared = 1;
        #10 read = 0; shared = 0;
     

        // Transition to Modified state (M)
        write = 1;
        #10 write = 0;


        // Transition to Invalid state (I) via snoop_write
        snoop_write = 1;
        #10 snoop_write = 0;


        // Transition to Exclusive state (E)
        exclusive = 1; read = 1;
        #10 exclusive = 0; read = 0;


        // Transition back to Modified state (M)
        write = 1;
        #10 write = 0;


        // Test snoop_read in Modified state
        snoop_read = 1;
        #10 snoop_read = 0;


        // Test snoop_write in Shared state
        snoop_write = 1;
        #10 snoop_write = 0;
  

        // End of simulation
        $finish;
    end
endmodule





