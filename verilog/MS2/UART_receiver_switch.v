`timescale 1ns / 1ps
// UART (Asynchronous) receiver, that gives 0/1 output on out output when 'a' keyboard key ascii value is received
    module UART_receiver_switch # (parameter key = 8'h61) ( 
      input clk, // input clock
      input uart_in, // input receiving data line
      //output [7:0] RxData, // output for 8 bits data
      output out // output level
      );
          
      //internal variables
      reg [3:0] bitcounter = 0; // 4 bits counter to count if 10 bits data transmission complete or not
      reg [1:0] samplecounter = 0; // 2 bits sample counter to count up to 4 for oversampling
      reg clear_bitcounter, inc_bitcounter, inc_samplecounter, clear_samplecounter; // clear or increment the counter
    
      reg [13:0] counter = 0; // 14 bits counter to count the baud rate (symbol rate) for UART receiving
      reg state = 0;  // initial state variable (mealy finite state machine)
      reg nextstate; // next state variable (mealy finite state machine)
      reg shift; // signal to indicate shifting data is ready
      reg [9:0] rxshiftreg; // 10 bits data needed to be shifted in during transmission. For storing the serial package and sending its bits one by one. The least significant bit is initialized with the binary value "0" (a start bit) A binary value "1" is introduced in the most significant bit
    
      reg output_reset = 0; // our output reset
      reg [31:0] time_counter = 0; // needed for our output reset
    
      // Constants (a parameter infers its type from its value)
      parameter clk_freq = 100_000_000;  // system clock frequency
      parameter baud_rate = 9_600; // baud rate (should be agreed upon with the transmitter)
      parameter oversamples = 4; // oversampling
      parameter reset_counter = clk_freq/(baud_rate*oversamples);  // counter upper bound
      // <------------ 100M clock cycles ----------->
      // <------------ 9,600 bits ------------------>
      // <------------ 9,600x4 samples ------------->
      // reset_counter = 2604, means counter goes from 0 to 2604 (during that time I should take 1 sample)
      parameter counter_mid_sample = (oversamples/2);  // this is the middle point of a bit where you want to sample it
      parameter num_bit = 10; // 1 start, 8 data, 1 stop
    
      //parameter key = 8'b01100001; // 8'b01100001; is the binary value of the ASCII character of small 'a' keyboard button
      parameter reset_high_seconds = 1;
      parameter reset_time_counter = clk_freq*reset_high_seconds;
    
    
      assign RxData = rxshiftreg [8:1]; // assign the RxData from the shiftregister
      assign out = output_reset;
    
      // UART receiver logic
      always @ (posedge clk) begin 
        counter <= counter +1; // start count in the counter
        if (counter >= reset_counter-1) begin // if counter reach the baud rate with sampling 
          counter <=0; //reset the counter
          state <= nextstate; // assign the state to nextstate
          if (shift)rxshiftreg <= {uart_in,rxshiftreg[9:1]}; //if shift asserted, load the receiving data
          if (clear_samplecounter) samplecounter <=0; // if clear sampl counter asserted, reset sample counter
          if (inc_samplecounter) samplecounter <= samplecounter +1; //if increment counter asserted, start sample count
          if (clear_bitcounter) bitcounter <=0; // if clear bit counter asserted, reset bit counter
          if (inc_bitcounter)bitcounter <= bitcounter +1; // if increment bit counter asserted, start count bit counter
        end
        
        // Handle our desired reset output
        // if (output_reset == 0 && rxshiftreg[8:1] == key)
           // output_reset <= 1;
        // if (output_reset == 1)
          // if (time_counter >= reset_time_counter) begin
            // time_counter <= 0;
            // output_reset <= 0;
            // rxshiftreg[8:1] <= 0;
          // end
          // else time_counter <= time_counter +1;
          
        if (rxshiftreg[8:1] == key) begin
           output_reset <= ~output_reset;
           rxshiftreg[8:1] <= 0;
           end 
//        else begin
//            output_reset <= output_reset;
//            //rxshiftreg[8:1] <= 0;
//           end 
          
      end
         
      // Finite state machine
      always @ (posedge clk) begin //trigger by clock 
        shift <= 0; // set shift to 0 to avoid any shifting 
        clear_samplecounter <=0; // set clear sample counter to 0 to avoid reset
        inc_samplecounter <=0; // set increment sample counter to 0 to avoid any increment
        clear_bitcounter <=0; // set clear bit counter to 0 to avoid claring
        inc_bitcounter <=0; // set increment bit counter to avoid any count
        nextstate <=0; // set next state to be idle state
        case (state)
          0: begin // idle state
            if (uart_in) // if input uart_in data line asserted
              nextstate <=0; // back to idle state because uart_in needs to be low to start transmission    
            else begin // if input uart_in data line is not asserted
              nextstate <=1; // jump to receiving state 
              clear_bitcounter <=1; // trigger to clear bit counter
              clear_samplecounter <=1; // trigger to clear sample counter
            end
          end
          1: begin // receiving state
            nextstate <= 1; // DEFAULT 
            if (samplecounter == counter_mid_sample - 1) shift <= 1; // if sample counter is 1, trigger shift 
            if (samplecounter == oversamples - 1) begin // if sample counter is 3 as the sample rate used is 3
              if (bitcounter == num_bit - 1) // check if bit counter if 9 or not
                nextstate <= 0; // back to idle state if bit counter is 9 as receving is complete
              inc_bitcounter <=1; // trigger the increment bit counter if bit counter is not 9
              clear_samplecounter <=1; //trigger the sample counter to reset the sample counter
            end
            else inc_samplecounter <=1; // if sample is not equal to 3, keep counting
          end
           default: nextstate <=0; //default idle state
         endcase
      end
    endmodule

