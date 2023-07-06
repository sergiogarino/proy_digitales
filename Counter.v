/**
 * Universidad de Costa Rica
 * Escuela de Ingeniería Eléctrica
 * Circuitos Digitales I - IE0323
 * Proyecto Verilog
 *
 * archivo: asm_ascensor.v
 * autores:
 * Sergio Garino Vargas - B73157
 * Johan Herrera Chaves - C03811
 *
 * Descripción: 
 * Modulo Counter capaz de contar de 0 a 3 con base en un contador de 4 bits 
 */


// Módulo para un contador de 4 bits con carga paralela y habilitador
module Counter_4bits(
    input clk, // Señal de reloj
    input rst, // Señal de reset activa en alto
    input en, // Señal de habilitador
    input [3:0] load, // Valor de carga paralela
    output reg [3:0] count // Salida del contador
);
    // Proceso sincrónico con el flanco positivo del reloj
    always @(posedge clk) begin
        if (rst) begin // Si la señal de reset está activa
            count <= 4'b0; // Se resetea el contador a 0
        end else if (en) begin // Si la señal de habilitador está activa
            count <= load; // Se carga el valor de carga paralela en el contador
        end else begin // Si ninguna de las anteriores condiciones se cumple
            count <= count + 1; // Se incrementa el contador en 1
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

// Módulo para un contador de 2 bits que cuenta de 0 a 3 y se resetea automáticamente
module Counter(
    input clk, // Señal de reloj
    input rst, // Señal de reset activa en alto
    input en, // Señal de habilitador
    input [3:0] load, // Valor de carga paralela
    output reg [3:0] count // Salida del contador
);
    wire nand_out; // Salida del módulo NAND
    
    // Instancia del módulo Counter_4bits
    Counter_4bits counter_4bits(
        .clk(clk),
        .rst(rst),
        .en(en),
        .load(load),
        .count(count)
    );
    
    // Instancia del módulo NAND 
    NAND nand(
        .a(count[1]), // La entrada A es el bit 1 de la salida del contador
        .b(count[0]), // La entrada B es el bit 0 de la salida del contador
        .y(nand_out) // La salida se conecta a nand_out
    );

        assign rst = nand_out; // La señal de reset se conecta a la salida del módulo NAND para resetear automáticamente el contador cuando llegue a 3 (11 en binario)
endmodule
