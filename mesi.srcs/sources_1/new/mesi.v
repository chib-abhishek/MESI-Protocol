`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/28/2024 07:51:40 PM
// Design Name: 
// Module Name: mesi
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


module mesi(
input clk,
input reset,
input read,write,snoop_read,snoop_write,shared, exclusive,
output reg [1:0] state,
output reg read_cache_line, broadcast_invalidate,write_cache_line_to_memory,invalidate_cache_line,write_cache_line
    );
    parameter M = 2'b00, S = 2'b01,I = 2'b10, E = 2'b11;
    reg [1:0] current_state = 2'b00, next_state;
    
    always @(posedge clk or posedge reset)
    begin
    if(reset)
    current_state <= I;
    else 
    current_state <= next_state;
    end
    
    
    always @(*) begin
    next_state = current_state;
    read_cache_line = 1'b0;
    broadcast_invalidate = 1'b0;
    write_cache_line_to_memory = 1'b0;
    invalidate_cache_line = 1'b0;
    write_cache_line = 1'b0;
    end
    
    always@(*)
    begin
    case(current_state)
    
    M:begin
    if(read)
    begin
    next_state = M;
    end
    
    else if(write)
    begin
    next_state = M;
    end
    
    else if(snoop_read)
    begin
    next_state = S; 
    write_cache_line_to_memory = 1'b1;
    end
    
    else if(snoop_write)
    begin
    next_state = I;
    write_cache_line_to_memory = 1'b1;
    end  
    end
    
    S:begin
    if(read)
    begin
    next_state = S;
    end
    
    else if(write)
    begin
    next_state = M;
    broadcast_invalidate = 1'b1;
    end
    
    else if(snoop_read)
    begin
    next_state = S; 
    end
    
    else if(snoop_write)
    begin
    next_state = I;
    invalidate_cache_line = 1'b1;
    end  
    end
    
    I:begin
    if(read && shared)
    begin
    next_state = S;
    read_cache_line = 1'b1;
    end   
    
    if(read && exclusive)
    begin
    next_state = E;
    read_cache_line = 1'b1;
    end 
    
    else if(write)
    begin
    next_state <= M;
    broadcast_invalidate = 1'b1;
    read_cache_line = 1'b1;
    write_cache_line = 1'b1;
    end 
    end   
    
    E:begin
    if(read)
    begin
    next_state = E;
    end
    
    else if(write)
    begin
    next_state = M;
    end
    
    else if(snoop_read)
    begin
    next_state = S; 
    end
    
    else if(snoop_write)
    begin
    next_state = I;
    invalidate_cache_line = 1'b1;
    end  
    end
    
    
    default: begin
    next_state = M; 
    end
    endcase
    end
endmodule
