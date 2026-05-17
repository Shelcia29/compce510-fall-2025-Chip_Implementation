`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Syed Mohsin Abbas
// 
// Design Name: 
// Module Name: bitonic_sorter
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


module bitonic_sorter( data_in,data_out,apply_TV,clk,reset

    );
    
    
    parameter N = 32;
    parameter width = 4; // soft messages width
    parameter width_ind=5;
    parameter stage_number = 5; // log2 8 = 3
    
    parameter layers = stage_number*(stage_number+1)/2;
    
    input clk,reset,apply_TV;

    
    input [N*width-1:0] data_in; // the data to be sorted, 
    
    output [N*width-1:0] data_out; //

   
    
    reg [N*width-1:0] data_pipe;

    reg [N*width-1:0] data_out; 

    wire [width-1:0] inter[layers:0][N-1:0]; // magniture

  
   
        genvar m;

    for (m=0;m<N;m=m+1) begin:  initilize
    assign inter[0][N-m-1] = data_in[(N-m)*width-1 -:width];

    end
    
    reg [3:0] sort_FSM;
    integer ii;

      always@(posedge clk)
    if(!reset) data_out <= 0;
	else begin
            for (ii=0; ii<N; ii=ii+1) 
            begin
            data_out[(N-ii)*width -1-:width] <= inter[15][N-ii-1];
            end
        end 
    
    always@(posedge clk)
    if(!reset) begin sort_FSM <= 0; data_pipe <= 0; end
    else case ( sort_FSM)
    4'd0: begin 
		data_pipe <= 0; 
		if (apply_TV) sort_FSM <= sort_FSM + 1; else  sort_FSM <= 0;
	   end
    4'd1: begin
            for (ii=0; ii<N; ii=ii+1) 
            begin
            data_pipe[(N-ii)*width-1-:width] <= inter[0][N-ii-1];
            end
            
            sort_FSM <= sort_FSM + 1; 
        end
    4'd2: begin
            for (ii=0; ii<N; ii=ii+1) 
            begin
            data_pipe[(N-ii)*width-1-:width] <= inter[1][N-ii-1];
            end
            sort_FSM <= sort_FSM + 1;
        end
    4'd3: begin
            for (ii=0; ii<N; ii=ii+1) 
            begin
            data_pipe[(N-ii)*width -1-:width] <= inter[3][N-ii-1];
            end
            sort_FSM <= sort_FSM + 1;
        end
    4'd4: begin
            for (ii=0; ii<N; ii=ii+1) 
            begin
            data_pipe[(N-ii)*width -1-:width] <= inter[6][N-ii-1];
            end
            sort_FSM <= sort_FSM + 1;
        end 
     4'd5: begin
            for (ii=0; ii<N; ii=ii+1) 
            begin
            data_pipe[(N-ii)*width -1-:width] <= inter[10][N-ii-1];
            end
            sort_FSM <= sort_FSM + 1;
        end 
     4'd6: begin
            for (ii=0; ii<N; ii=ii+1) 
            begin
            data_pipe[(N-ii)*width -1-:width] <= inter[15][N-ii-1];
            end
            sort_FSM <= sort_FSM + 1;
        end 
    default: begin data_pipe <= 0; sort_FSM <= 0; end
    endcase
    

    genvar i,j,k,l,o,p;
    for (i=stage_number-1;i>0;i=i-1) begin: stages
        for(j=0;j<i-1;j=j+1) begin:  layer_per_stage
        for(o=0;o<(2**(stage_number-i)) ;o=o+2) begin : block_size_per_stage // (2**(stage_number-i))   ............. o*(N/(2**(stage_number-i)))
            for(k=0;k<(2**(i-j-1));k=k+1) begin:  Tupples_number // (2**(stage_number-j-o-2))
                for(l=0;l<((N/2)/(2**(stage_number-j-1)));l=l+1) begin:  PE_1 // in a tupple
               
                 // PE size = N / (2**(stage_number-j-1)) ;; N / tupple_number
                assign inter[((i*(i+1)/2)-j)][l + k*( N / (2**(stage_number-j-1))) + o*(N/(2**(stage_number-i)))] = inter[((i*(i+1)/2)-j-1)][l + k*( N / (2**(stage_number-j-1))) + o*(N/(2**(stage_number-i)))]  > inter[((i*(i+1)/2)-j-1)][l + k*( N / (2**(stage_number-j-1))) + o*(N/(2**(stage_number-i))) + ((N/2)/(2**(stage_number-j-1)))] ? inter[((i*(i+1)/2)-j-1)][l + k*( N / (2**(stage_number-j-1))) + o*(N/(2**(stage_number-i))) + ((N/2)/(2**(stage_number-j-1)))]  : inter[((i*(i+1)/2)-j-1)][l + k*( N / (2**(stage_number-j-1))) + o*(N/(2**(stage_number-i)))] ;
                assign inter[((i*(i+1)/2)-j)][l + k*( N / (2**(stage_number-j-1))) + o*(N/(2**(stage_number-i))) + ((N/2)/(2**(stage_number-j-1)))] = inter[((i*(i+1)/2)-j-1)][l + k*( N / (2**(stage_number-j-1))) + o*(N/(2**(stage_number-i)))]  > inter[((i*(i+1)/2)-j-1)][l + k*( N / (2**(stage_number-j-1))) + o*(N/(2**(stage_number-i))) + ((N/2)/(2**(stage_number-j-1)))] ? inter[((i*(i+1)/2)-j-1)][l + k*( N / (2**(stage_number-j-1))) + o*(N/(2**(stage_number-i)))]  :  inter[((i*(i+1)/2)-j-1)][l + k*( N / (2**(stage_number-j-1))) + o*(N/(2**(stage_number-i))) + ((N/2)/(2**(stage_number-j-1)))] ;
                
      
                end
                
                for(l=0;l<((N/2)/(2**(stage_number-j-1)));l=l+1) begin:  PE_2 // in a tupple
               
                 // PE size = N / (2**(stage_number-j-1)) ;; N / tupple_number
                 assign inter[((i*(i+1)/2)-j)][l + k*( N / (2**(stage_number-j-1))) + (o+1)*(N/(2**(stage_number-i)))] = inter[((i*(i+1)/2)-j-1)][l + k*( N / (2**(stage_number-j-1))) + (o+1)*(N/(2**(stage_number-i)))]  < inter[((i*(i+1)/2)-j-1)][l + k*( N / (2**(stage_number-j-1))) + (o+1)*(N/(2**(stage_number-i))) + ((N/2)/(2**(stage_number-j-1)))] ? inter[((i*(i+1)/2)-j-1)][l + k*( N / (2**(stage_number-j-1))) + (o+1)*(N/(2**(stage_number-i))) + ((N/2)/(2**(stage_number-j-1)))]  : inter[((i*(i+1)/2)-j-1)][l + k*( N / (2**(stage_number-j-1))) + (o+1)*(N/(2**(stage_number-i)))] ;
                assign inter[((i*(i+1)/2)-j)][l + k*( N / (2**(stage_number-j-1))) + (o+1)*(N/(2**(stage_number-i))) + ((N/2)/(2**(stage_number-j-1)))] = inter[((i*(i+1)/2)-j-1)][l + k*( N / (2**(stage_number-j-1))) + (o+1)*(N/(2**(stage_number-i)))]  < inter[((i*(i+1)/2)-j-1)][l + k*( N / (2**(stage_number-j-1))) + (o+1)*(N/(2**(stage_number-i))) + ((N/2)/(2**(stage_number-j-1)))] ? inter[((i*(i+1)/2)-j-1)][l + k*( N / (2**(stage_number-j-1))) + (o+1)*(N/(2**(stage_number-i)))]  :  inter[((i*(i+1)/2)-j-1)][l + k*( N / (2**(stage_number-j-1))) + (o+1)*(N/(2**(stage_number-i))) + ((N/2)/(2**(stage_number-j-1)))] ;
                
                  
                end
                
              end  
            end
        end
  /////////////////////// pipelined layer at each stage ; j = i-1

        for(o=0;o<(2**(stage_number-i)) ;o=o+2) begin : block_size_per_stage_pipelined_stage 
            for(k=0;k<(2**(i-(i-1)-1));k=k+1) begin:  Tupples_number // (2**(stage_number-(i-1)-o-2))
                for(l=0;l<((N/2)/(2**(stage_number-(i-1)-1)));l=l+1) begin:  PE_1 // in a tupple
               
                 // PE size = N / (2**(stage_number-(i-1)-1)) ;; N / tupple_number
                  
                assign inter[((i*(i+1)/2)-(i-1))][l + k*( N / (2**(stage_number-(i-1)-1))) + o*(N/(2**(stage_number-i)))] = data_pipe[(l +1+ k*( N / (2**(stage_number-(i-1)-1))) + o*(N/(2**(stage_number-i))))*width -1-:width] > data_pipe[(l +1+ k*( N / (2**(stage_number-(i-1)-1))) + o*(N/(2**(stage_number-i))) + ((N/2)/(2**(stage_number-(i-1)-1))))*width -1-:width] ? data_pipe[(l +1+ k*( N / (2**(stage_number-(i-1)-1))) + o*(N/(2**(stage_number-i))) + ((N/2)/(2**(stage_number-(i-1)-1))))*width -1-:width] : data_pipe[(l +1+ k*( N / (2**(stage_number-(i-1)-1))) + o*(N/(2**(stage_number-i))))*width -1-:width];
                assign inter[((i*(i+1)/2)-(i-1))][l + k*( N / (2**(stage_number-(i-1)-1))) + o*(N/(2**(stage_number-i))) + ((N/2)/(2**(stage_number-(i-1)-1)))] = data_pipe[(l +1+ k*( N / (2**(stage_number-(i-1)-1))) + o*(N/(2**(stage_number-i))))*width -1-:width] > data_pipe[(l +1+ k*( N / (2**(stage_number-(i-1)-1))) + o*(N/(2**(stage_number-i))) + ((N/2)/(2**(stage_number-(i-1)-1))))*width -1-:width] ? data_pipe[(l +1+ k*( N / (2**(stage_number-(i-1)-1))) + o*(N/(2**(stage_number-i))))*width -1-:width] : data_pipe[(l + 1 + k*( N / (2**(stage_number-(i-1)-1))) + o*(N/(2**(stage_number-i))) + ((N/2)/(2**(stage_number-(i-1)-1))))*width -1-:width] ;
                             

              
                end
                
                for(l=0;l<((N/2)/(2**(stage_number-(i-1)-1)));l=l+1) begin:  PE_2 // in a tupple
               
                 // PE size = N / (2**(stage_number-(i-1)-1)) ;; N / tupple_number
                 assign inter[((i*(i+1)/2)-(i-1))][l + k*( N / (2**(stage_number-(i-1)-1))) + (o+1)*(N/(2**(stage_number-i)))] = data_pipe[(l +1+ k*( N / (2**(stage_number-(i-1)-1))) + (o+1)*(N/(2**(stage_number-i))))*width -1-:width] < data_pipe[(l +1+ k*( N / (2**(stage_number-(i-1)-1))) + (o+1)*(N/(2**(stage_number-i))) + ((N/2)/(2**(stage_number-(i-1)-1))))*width -1-:width] ? data_pipe[(l +1+ k*( N / (2**(stage_number-(i-1)-1))) + (o+1)*(N/(2**(stage_number-i))) + ((N/2)/(2**(stage_number-(i-1)-1))))*width -1-:width] : data_pipe[(l +1+ k*( N / (2**(stage_number-(i-1)-1))) + (o+1)*(N/(2**(stage_number-i))))*width -1-:width];
                 assign inter[((i*(i+1)/2)-(i-1))][l + k*( N / (2**(stage_number-(i-1)-1))) + (o+1)*(N/(2**(stage_number-i))) + ((N/2)/(2**(stage_number-(i-1)-1)))] = data_pipe[(l +1+ k*( N / (2**(stage_number-(i-1)-1))) + (o+1)*(N/(2**(stage_number-i))))*width -1-:width] < data_pipe[(l +1+ k*( N / (2**(stage_number-(i-1)-1))) + (o+1)*(N/(2**(stage_number-i))) + ((N/2)/(2**(stage_number-(i-1)-1))))*width -1-:width] ? data_pipe[(l +1+ k*( N / (2**(stage_number-(i-1)-1))) + (o+1)*(N/(2**(stage_number-i))))*width -1-:width] : data_pipe[(l + 1 + k*( N / (2**(stage_number-(i-1)-1))) + (o+1)*(N/(2**(stage_number-i))) + ((N/2)/(2**(stage_number-(i-1)-1))))*width -1-:width] ;

                 
                end
                
              end  
         end
  /////////////////////////////////////////////////////////////      
    end
    
        // i = stage_number, Last stage, N = 32, 5 layers
        
    // first layer; j = 0
            for(k=0;k<1;k=k+1) begin:  Tupples_number_last
                for(l=0;l<(N/2);l=l+1) begin:  PE_last // in a tupple
                // PE size = N / (2**(stage_number-1)) ;; N / tupple_number
                assign inter[((stage_number*(stage_number+1)/2)-stage_number+1)][l ] = data_pipe[(l+1)*width -1-:width]  < data_pipe[(l + (N/2)+1)*width -1-:width] ? data_pipe[(l + (N/2)+1)*width -1-:width]  : data_pipe[(l+1)*width -1-:width] ;
                assign inter[((stage_number*(stage_number+1)/2)-stage_number+1)][l  + (N/2)] = data_pipe[(l+1)*width -1-:width]  < data_pipe[(l + (N/2)+1)*width -1-:width] ? data_pipe[(l+1)*width -1-:width]  :  data_pipe[(l + (N/2)+1)*width -1-:width] ;
                
                

                end
            end  
              
    for(j=0;j<stage_number-1;j=j+1) begin:  layer_per_stage_last
            for(k=0;k<(2**(stage_number-j-1));k=k+1) begin:  Tupples_number_last
                for(l=0;l<((N/2)/(2**(stage_number-j-1)));l=l+1) begin:  PE_last // in a tupple
                // PE size = N / (2**(stage_number-j-1)) ;; N / tupple_number
                assign inter[((stage_number*(stage_number+1)/2)-j)][l + k*( N / (2**(stage_number-j-1)))] = inter[((stage_number*(stage_number+1)/2)-j-1)][l + k*( N / (2**(stage_number-j-1)))]  < inter[((stage_number*(stage_number+1)/2)-j-1)][l + k*( N / (2**(stage_number-j-1))) + ((N/2)/(2**(stage_number-j-1)))] ? inter[((stage_number*(stage_number+1)/2)-j-1)][l + k*( N / (2**(stage_number-j-1))) + ((N/2)/(2**(stage_number-j-1)))]  : inter[((stage_number*(stage_number+1)/2)-j-1)][l + k*( N / (2**(stage_number-j-1)))] ;
                assign inter[((stage_number*(stage_number+1)/2)-j)][l + k*( N / (2**(stage_number-j-1))) + ((N/2)/(2**(stage_number-j-1)))] = inter[((stage_number*(stage_number+1)/2)-j-1)][l + k*( N / (2**(stage_number-j-1)))]  < inter[((stage_number*(stage_number+1)/2)-j-1)][l + k*( N / (2**(stage_number-j-1))) + ((N/2)/(2**(stage_number-j-1)))] ? inter[((stage_number*(stage_number+1)/2)-j-1)][l + k*( N / (2**(stage_number-j-1)))]  :  inter[((stage_number*(stage_number+1)/2)-j-1)][l + k*( N / (2**(stage_number-j-1))) + ((N/2)/(2**(stage_number-j-1)))] ;


                end
            end
        end
 
    
   

    
endmodule
