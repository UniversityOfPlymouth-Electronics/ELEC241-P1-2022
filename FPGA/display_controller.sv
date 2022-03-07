module display_controller (
   output logic [7:0] data,
   output logic rs,
   output logic rw,
   output logic e,
   input logic [7:0] ascii_data,
   input logic write,
   input logic clk);
   
   // ROM for testing the LCD
	reg [10:0] rom[2:0] = '{
	
      //
		{3'b000,8'b00000000}, 
		{3'b000,8'b00000000}, 
		{3'b000,8'b00000000}, 
		{3'b000,8'b00000000}, 
		{3'b000,8'b00000000}, 
		{3'b000,8'b00000000}, 
		{3'b000,8'b00000000}, 
		{3'b000,8'b00000000}
      
		}; /* synthesis romstyle = "M9K" */
 
   logic [2:0] addr = '0; 
 
always_ff @(posedge clk) begin

   
   data <= rom[addr][7:0];
   rs   <= rom[addr][8];
   rw   <= rom[addr][9];
   e    <= rom[addr][10];

end
   
   
endmodule
   