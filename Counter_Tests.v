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
module Counter_Tests(
	output reg clk, enb,
	output reg modo,
	output reg [3:0] data,
	input wire [3:0] Q);
	
	//Defino el reloj 
	initial clk = 0; 
	always #1 clk = ~clk;

	initial
	begin

	    $dumpfile("Counter.vcd");
	    $dumpvars;

		//Prubas para el contador de 4 bits

	    // Prueba 1 - Cuenta Ascendente 
        modo    = 1;
		#3 enb  = 1;
		#1 data = 0;
		#3 modo = 0;
		#50 enb = 0;        	
		
		#10 $finish;
		
	end 

endmodule