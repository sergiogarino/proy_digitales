/**
 * Universidad de Costa Rica
 * Escuela de Ingeniería Eléctrica
 * Circuitos Digitales I - IE0323
 * Proyecto Verilog
 *
 * archivo: Counter.v
 * autores:
 * Sergio Garino Vargas - B73157
 * Johan Herrera Chaves - C03811
 *
 * Descripción: 
 * Modulo Counter capaz de contar de 0 a 3 con base en un contador de 4 bits 
 */

/**
* Contador de 4 bits, sincronico, con habilitador y entrada de 
* datos paralela y salida de Ripple Carry Out (rco)
* Ademas, posee una entrada de 2 bits para elegir el modo de 
* funcionamiento del contador, de la siguiente forma:
*
* Modo    Descripcion
* 0 : Cuenta ascendente de 1 en 1. RC0 = 1 cuando Q = 15
* 1 : Carga de Datos Paralela. Permite inicializar el contador 
*     en una cuenta particular.
**/

// Módulo para un contador de 4 bits con carga paralela y habilitador
module Counter_4bits(
	input wire clk, enb, rst,
	input wire modo,
	input wire [3:0] data, 
	output reg [3:0] Q
);

always @(posedge clk)
begin
	
	if (enb)
	begin
    case(modo)
        // Modo conteo
        0: begin
            if (~rst)
            begin
                Q <= 0;
            end
            else
            begin
                Q <= Q + 1;
            end
        end 

        // Modo carga paralela
        1: begin
            Q <= data;		// Inicializar mi contador con el valor de data.
        end
    
        default: begin
            Q <= Q + 1;
        end
    
    endcase
	end
	
end

endmodule


// Módulo para una compuerta lógica NAND de 2 entradas
module NAND(
    input a, // Entrada A
    input b, // Entrada B
    output y // Salida Y
);
    assign y = ~(a & b); // La salida Y es el resultado de aplicar la operación NAND a las entradas A y B
endmodule


module Counter(
    input clk, enb, // Señal de reloj, enable y reset
    input modo,
    input [3:0] data, // Valor de carga paralela
    output [3:0] Q // Salida del contador de 4 bits
);

    wire nand_a;
    wire nand_b;
    wire nand_out_rst;

    assign nand_a = Q[0];
    assign nand_b = Q[1];

    // Instancia del módulo Counter_4bits
    Counter_4bits counter_4bits(
        .clk(clk), // entrada
        .enb(enb), // entrada
        .rst(nand_out_rst),
        .modo(modo),
        .data(data),
        .Q(Q)
    );    

    // Instancia del módulo NAND
    NAND nand_inst(
        .a(nand_a), // La entrada A es el bit 1 de la salida del contador
        .b(nand_b), // La entrada B es el bit 0 de la salida del contador
        .y(nand_out_rst)); // La salida se conecta a nand_out
endmodule
