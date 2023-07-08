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
 * En este archivo se tiene la implemetación del Diagrama ASM del 
 * ascensor.
 */

/** IMPORTANTE!!!!!!!!!!
* Para correr este tench se deben de poner los siguientes comandos en una
* terminal Linux que tenga instalada iverilog, vvp y gtkwave
***************************************************
iverilog -o ElevadorPrueba Elevator_Tests.v
vvp ElevadorPrueba
gtkwave Elevator.vcd
***************************************************
**/


module Elevator (
    input Clk, Reset, /**< Entradas de Clock y Reset */
    input I0, I1, I2, /**< Botones internos */
    input E0, E1, E2, /**< Botones externos */
    input S0, S1, S2, /**< Sensores de posición */ 
    input R, /**< Señal que se pone en alto cuando el tiempo para tener la puerta abierta expiró */
    output M, D, /**< Bits para controlar el (M)otor a activar y la (D)irección */ 
    output P, W, /**< Bits para regular la velocidad de los 2 motores mediante PWM*/
    output S); /**< Sonido que se activa antes de abrir la puerta */
    /**
     * Se definen dos vectores, uno de estado presente y otro para el próximo 
     * estado los cuales son de 4 cuatro por que el diseño de la ASM se
     * tiene 14 estados posibles que son requesentables con 4 bits.
     */

    reg [3:0] estadoPresente, proximoEstado;

    /**
     * Se asignan los estados con base en el ASM
     */
    parameter a = 4'b0000; // 0
    parameter b = 4'b0001; // 1
    parameter c = 4'b0010; // 2
    parameter d = 4'b0011; // 3
    parameter e = 4'b1100; // C
    parameter f = 4'b0100; // 4
    parameter g = 4'b0101; // 5
    parameter h = 4'b0110; // 6
    parameter i = 4'b0111; // 7
    parameter j = 4'b1000; // 8
    parameter k = 4'b1001; // 9
    parameter p = 4'b1010; // A
    parameter u = 4'b1011; // B
    parameter t = 4'b1101; // D

    /**
     * La memoria de estados
     */

    always @(posedge Clk, posedge Reset)
    begin
        if (Reset) estadoPresente <= a;
        else       estadoPresente <= proximoEstado;
    end

    /**
     * Cálculo de lógica de próximo estados: mediante una sentencia always se
     * determina el siguiente estado partiendo de cada uno de los estados
     */

    always @(*)
    begin
        case (estadoPresente)
        // Partiendo del estado a
        a:
        casez({S0, S1, S2})
            3'b1??: proximoEstado = b;
            3'b01?: proximoEstado = c;
            3'b001: proximoEstado = d;
            3'b000: proximoEstado = a;
        endcase
        // Partiendo del estado b
        b:
        casez ({E0, I2, E2, E1, I1})
            5'b1????: proximoEstado = p; 
            5'b01???: proximoEstado = f;
            5'b001??: proximoEstado = f;
            5'b0001?: proximoEstado = h;
            5'b00001: proximoEstado = h;
            5'b00000: proximoEstado = b;
        endcase
        // Partiendo del estado c
        c:
        casez ({E1, I2, E2, I0, E0})
            5'b1????: proximoEstado = p;
            5'b01???: proximoEstado = i;
            5'b001??: proximoEstado = i;
            5'b0001?: proximoEstado = j;
            5'b00001: proximoEstado = j;
            5'b00000: proximoEstado = c;
        endcase
        // Partiendo del estado d
        d:
        casez ({E2, I0, E0, E1, I1})
            5'b1????: proximoEstado = p;
            5'b01???: proximoEstado = g;
            5'b001??: proximoEstado = g;
            5'b0001?: proximoEstado = k;
            5'b00001: proximoEstado = k;
            5'b00000: proximoEstado = d;
        endcase
        // Partiendo del estado e
        e:
        begin
            if (R) proximoEstado = t;
            else proximoEstado = e;
        end
        // Partiendo del estado f
        f:
        begin
            if (S1) proximoEstado = i;
            else proximoEstado = f;
        end
        // Partiendo del estado g
        g:
        begin
            if (S1) proximoEstado = j;
            else proximoEstado = g;
        end
        // Partiendo del estado h
        h:
        begin
            if (S1) proximoEstado = p;
            else proximoEstado = h;
        end
        // Partiendo del estado y
        i:
        begin
            if (S2) proximoEstado = p;
            else proximoEstado = i;
        end
        // Partiendo del estado j
        j:
        begin
            if (S0) proximoEstado = p;
            else proximoEstado = j;
        end
        // Partiendo del estado k
        k:
        begin
            if (S1) proximoEstado = p;
            else proximoEstado = k;
        end
        // Partiendo del estado p, la transicón es incondicional al estado u
        p:
            proximoEstado = u;
        // Partiendo del estado u
        u:
            proximoEstado = e;
        // Partiendo del estado t
        t:
            proximoEstado = a;
        endcase
    end

    /**
     * La lógica de cálculo de salidas permite activar las salidas
     */
    /**
     * Las salidas M y D funcionan de la siguiente manera
     * (MD): Motor, dirección
     * (00): Motor 0, bajar
     * (01): Motor 0, subir
     * (10): Motor 1, cerrar
     * (11): Motor 1, abrir
     *
     * Las salidas P y W funcionan de la siguiente manera:
     * (PW): Velocidad, Ciclo de trabajo
     * (00): Detenido, Ciclo de trabajo = 25%
     * (01): Lento, Ciclo de trabajo = 25%
     * (10): Medio, Ciclo de trabajo = 50%
     * (11): Rápido, Ciclo de trabajo = 75%
     * 
     * La salida S se activa antes de abrir la puerta
     */
    assign M = (estadoPresente == u | estadoPresente == t); 

    assign D = (estadoPresente == f | 
                estadoPresente == h | 
                estadoPresente == i | 
                estadoPresente == u);

    assign P = (estadoPresente == f | 
                estadoPresente == g | 
                estadoPresente == h | 
                estadoPresente == i | 
                estadoPresente == j | 
                estadoPresente == k);

    assign W = (estadoPresente == f | 
                estadoPresente == g | 
                estadoPresente == u | 
                estadoPresente == t);

    assign S = (estadoPresente == p);

endmodule