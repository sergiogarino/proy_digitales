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
 * Test bench para el módulo Elevator
 */

`timescale 1ps/1ps
`include "Elevator.v"

module Elevator_Tester;

    /**
    * Se definen como reg lo que la máquina recibe como entradas
    **/
    reg Clk, Reset;
    reg I0, I1, I2;
    reg E0, E1, E2;
    reg S0, S1, S2;
    reg R;

    /**
    * Se definen como wires lo que la máquina da como salidas
    **/
    wire M, D;
    wire P, W;
    wire S;

    /**
    * Se definen los vectores de pruebas cada uno de ellos tiene tamaño 10
    * debido a que se tienen las 10 entradas I0, I1, I2, E0, E1, E2,S0, S1,
    * S2 y R, la cantidad de vectores depende del número de pruebas que se
    * deseen realizar, en este caso se hacen X pruebas
    **/
    reg [9:0] testvectors [6:0];
    integer vectornum;

    /**
    * Se realiza una instanción nombrada del módulo Elevator bajo el nombre de
    * uut
    **/
    Elevator uut (
        .Clk(Clk), .Reset(Reset),
        .I0(I0), .I1(I1), .I2(I2),
        .E0(E0), .E1(E1), .E2(E2),
        .S0(S0), .S1(S1), .S2(S2),
        .R(R));

    /**
    * Estas son las pruebas que se le realizan a la máquina, el orden de las
    * entradas es:
    * I0, I1, I2, E0, E1, E2, S0, S1, S2, R
    **/
    initial
    begin
        testvectors[0] = 10'b0001_1111_11;

        vectornum = 0;

        Reset = 1;
        #3 Reset = 0;

        $dumpfile("Elevator.vcd");
        $dumpvars;
    end
    
    /**
    * Se define la señal de reloj
    **/

    always
    begin
        Clk = 1; #5; Clk = 0; #5;  
    end

    always @(posedge Clk)
    begin
    #1 if (!Reset)
        begin
            $display ("Las salidas son M=%b, D=%b, P=%b, W=%b, S=%b", M, D, P, W, S);
            vectornum = vectornum + 1;
                if (vectornum == 7/*Cantidad de pruebas*/)
                begin
                    $finish;
                end
        end
    end
endmodule