module display_controller (
   output logic [7:0] data,
   output logic rs,
   output logic rw,
   output logic e,
   input logic [7:0] ascii_data,
   input logic write,
   input logic clk);

// Clock is 10MKz so:
// 1 cycle = 100 us
// 10 cycles = 1 ms
// 

logic [17:0] counter1 = 18'b0;      // count up to 262144
logic [17:0] counter2 = 18'b0;
int eholdUP = 80;
int eholdDOWN = 40;
int initcount = 0;
int initdelay = 0;
int writedelay1 = 40;
int writedelay2 = 80;
int writedelay3 = 120;

enum {init, initwait, run} current_state;
   

 
always_ff @(posedge clk) begin

   case (current_state)
      init:   begin
                  case (initcount)
                     0:    // initialise stage power on wait
                        begin
                         //data <= 8'b00111100;
                         e <= 1'b1;
                         initdelay <= 500;    // delay 50 ms power on delay
                         current_state = initwait;
                        end
                     1:    // initialise stage 2
                        begin
                         rs   <= 1'b0;     // instruction
                         rw   <= 1'b0;     // write
                         data <= 8'b00110000;
                         initdelay <= 50;    // delay 50 us
                        end
                     2:    // initialise stage 3 Display ON
                        begin
                         rs   <= 1'b0;     // instruction
                         rw   <= 1'b0;     // write
                         data <= 8'b00110000;
                         initdelay <= 50;    // delay 50 us
                        end                     
                     3:    // initialise stage 4 
                        begin
                         rs   <= 1'b0;     // instruction
                         rw   <= 1'b0;     // write
                         data <= 8'b00110000;
                         initdelay <= 50;    // delay 
                        end
                     4:    // initialise stage 5 
                        begin
                         rs   <= 1'b0;     // instruction
                         rw   <= 1'b0;     // write
                         data <= 8'b00111000;      //8 bits 2 lines 5x8
                         initdelay <= 50;    // delay 
                        end
                     5:    // initialise stage 6 
                        begin
                         rs   <= 1'b0;     // instruction
                         rw   <= 1'b0;     // write
                         data <= 8'b00001100;   // display on
                         initdelay <= 50;    // delay 
                        end
                     6:    // initialise stage 7 
                        begin
                         rs   <= 1'b0;     // instruction
                         rw   <= 1'b0;     // write
                         data <= 8'b00000001;   // clear display
                         initdelay <= 500;    // delay 
                        end
                     7:    // initialise stage 8 
                        begin
                         rs   <= 1'b0;     // instruction
                         rw   <= 1'b0;     // write
                         data <= 8'b11000000;   // locate to bottom row
                         initdelay <= 50;    // delay 
                        end
                  endcase
                  
                  counter1 <= counter1 + 1'b1;
                  
                  if (counter1 > eholdDOWN && counter1 < eholdUP)
                     begin
                       e <= 1'b0; 
                     end
                  if (counter1 == eholdUP)
                     begin
                        e    <= 1'b1;
                        initdelay <= 50;
                        current_state = initwait;
                        counter1 <= 0;
                     end
               end
      initwait:   begin
                     counter1 <= counter1 + 1'b1;
                     if (counter1 == initdelay)
                        begin
                           if (initcount == 7)    // init sequence complete
                              begin
                                 e <= 1'b1;
                                 current_state = run; // start to process inputs
                                 counter1 <= 0;
                              end
                           else
                              begin
                                 initcount++;
                                 current_state = init;   // continue with init sequence
                                 counter1 <= 0;
                              end
                           
                        end
                     
                  end
      run:     begin
                  //if (write == 1)
                     begin
                        

                        rw <= 1'b0; 
                        rs <= 1'b1;    
                        
                        data <= 8'h4D; // send 'M'
                        
                        counter1 <= counter1 + 1'b1;
                        if (counter1 == 1)
                           begin
                              e <= 1'b1;
                           end

                        if (counter1 == writedelay1) 
                           begin
                              e <= 1'b0;
                           end
                        
                        if (counter1 == writedelay2 )
                           begin
                              e <= 1'b1;
                              counter1 <= 1'b0;
                           end

                        // data <= 8'h4E; // send 'N'
                        // counter1 <= counter1 + 1'b1;
                        // if (counter1 > writedelay1) 
                        //    begin
                        //       e <= 1'b0;
                        //    end
                        
                        // if (counter1 == writedelay2 )
                        //    begin
                        //       e <= 1'b1;
                        //       counter1 <= 1'b0;
                        //    end
                     end
                  
               end
   endcase
   
   


end
   
   
endmodule
   
