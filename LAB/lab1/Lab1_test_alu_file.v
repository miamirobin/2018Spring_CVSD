`timescale 1ns/100ps

module test_alu;
reg [3:0] inputA,inputB,true_out;
reg clk,reset,instruction;
wire [3:0] alu_out;

reg [8:0] program [0:511];
reg [3:0] answer [0:511];

reg [8:0] fetch;

integer i,j,outfile,pat_error;

  ALU my_alu(alu_out,instruction,inputA,inputB,clk,reset);

always #10 clk=~clk;                      //cycle time is 20ns



   
initial begin
  outfile=$fopen("alu_out.txt");          //open one file for writing
  if(!outfile) begin
    $display("Can not write file!");
    $finish;
  end
  $readmemb("program.txt",program);
  $readmemb("program_out.txt",answer);
  

  pat_error=0;

  reset=1'b1;clk=1'b1;inputA=0;inputB=0;instruction=0;
  #5 reset=1'b0;                            // system reset
  #5 reset=1'b1;
     // test for instruction 0: Add
     for(i=0;i<16;i=i+1)
     begin
       for(j=0;j<16;j=j+1)
       begin
         fetch=program[i*16+j];
         inputA=fetch[8:5];inputB=fetch[4:1];instruction=fetch[0];
         #20 
             if(alu_out !== answer[i*16+j]) 
             begin
               $fdisplay(outfile,"%b + %b should be %b. But your output is %b.",inputA,inputB,answer[i*16+j],alu_out);
               pat_error=pat_error+1;
             end                           
       end
     end
     
     // test for instruction 1: Sub
     for(i=0;i<16;i=i+1)
     begin
       for(j=0;j<16;j=j+1)
       begin
         fetch=program[i*16+j+256];
         inputA=fetch[8:5];inputB=fetch[4:1];instruction=fetch[0];
         #20 
             if(alu_out !== answer[i*16+j+256]) 
             begin
               $fdisplay(outfile,"%b - %b should be %b. But your output is %b.",inputA,inputB,answer[i*16+j+256],alu_out);
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