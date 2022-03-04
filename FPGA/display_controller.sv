module display_controller (
   output logic [7:0] data,
   output logic rs,
   output logic rw,
   output logic e,
   input logic [7:0] ascii_data,
   input logic write,
   input logic clk);
   
always_ff @(posedge clk) begin

   data <= 8'd0;
   rs   <= 1'b0;
   rw   <= 1'b0;
   e    <= 1'b0;

end
   
   
endmodule
   