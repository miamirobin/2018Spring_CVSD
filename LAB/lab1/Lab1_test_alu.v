`timescale 1ns/100ps

module test_alu;
reg [3:0] inputA,inputB,true_out;
reg clk,reset,instruction;
wire [3:0] alu_out;

integer i,j,outfile,pat_error;

  ALU my_alu(alu_out,instruction,inputA,inputB,clk,reset);

always #10 clk=~clk;                      //cycle time is 20ns
   
initial begin
  outfile=$fopen("alu_out.txt");          //open one file for writing
  if(!outfile) begin
    $display("Can not write file!");
    $finish;
  end

  pat_error=0;

  reset=1'b1;clk=1'b1;inputA=0;inputB=0;instruction=0;
  #5 reset=1'b0;                            // system reset
  #5 reset=1'b1;
     // test for instruction 0: Add
     instruction=0;
     for(i=0;i<16;i=i+1)
     begin
       for(j=0;j<16;j=j+1)
       begin
         inputA=i[3:0];inputB=j[3:0];
         #20 true_out=inputA+inputB;
             if(alu_out !== true_out[3:0]) 
             begin
               $fdisplay(outfile,"%b + %b should be %b. But your output is %b.",inputA,inputB,true_out,alu_out);
               pat_error=pat_error+1;
             end                           
       end
     end
     
     // test for instruction 1: Sub
     instruction=1'b1;
     for(i=0;i<16;i=i+1)
     begin
       for(j=0;j<16;j=j+1)
       begin
         inputA=i[3:0];inputB=j[3:0];
         #20 true_out=inputA-inputB;
             if(alu_out !== true_out[3:0]) 
             begin
               $fdisplay(outfile,"%b - %b should be %b. But your output is %b.",inputA,inputB,true_out,alu_out);
               pat_error=pat_error+1;
             end                           
       end
     end
          
     if(!pat_error)
       $display("\nCongratulations!! Your Verilog Code is correct!!\n");
     else
       $display("\nYour Verilog Code has %d errors. \nPlease read alu_out.txt for details.\n",pat_error);
  #10 $finish;
  


end

endmodule