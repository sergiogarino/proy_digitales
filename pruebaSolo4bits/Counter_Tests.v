/**
 * Universidad de Costa Rica
 * Escuela de Ingeniería Eléctrica
 * Circuitos Digitales I - IE0323
 * Proyecto Verilog
 *
 * archivo: asm_ascensor.v
 * autores:
 * Sergio Garino Vargas - B73157
 * Johan - 
 *
 * Descripción: 
 * Test bench para el módulo Counter
 */
module Test_bench(
	output reg clk, enb, rst,
	output reg modo,
	output reg [3:0] data,
	input wire [3:0] Q
	);
	
	//Defino el reloj 
	initial clk = 0; 
	always #1 clk = ~clk;

	
	initial
	begin

	    $dumpfile("contador4.vcd");
	    $dumpvars;

		//Prubas para el contador de 4 bits

	    // Prueba 1 - Cuenta Ascendente 
        modo    = 1;
        #1 rst  = 1;
		#1 enb  = 0;
		#3 enb  = 1;
		#1 data = 0;
		#3 modo = 0;
        #60 rst = 0;
        #10 rst = 1;
        #10 rst = 0;
        #10 rst = 1;
        #10 rst = 0;
        #10 rst = 1;

		#50 enb = 0;
		
	    // Prueba 4 - Carga paralela		
		modo    = 1;
		#5 enb  = 1;		
		#4 data = 6;
        #5 modo = 0;
		#30 enb = 0;
		#10 $finish;
		
	end 

endmodule