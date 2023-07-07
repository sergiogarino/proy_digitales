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


`include "Counter.v"
`include "Counter_Tests.v"

/*
* probador
* Agrega conexiones entre el UUT (contador de 4 bits) y su testbench.
*/
module probador();

	wire clk, enb, rst;
	wire modo;
	wire [3:0] data, Q;

Test_bench signals_generator(.clk(clk), .enb(enb), .rst(rst), .modo(modo), .data(data), .Q(Q));
counter4 UUT(.clk(clk), .enb(enb), .rst(rst), .modo(modo), .data(data), .Q(Q));

endmodule
