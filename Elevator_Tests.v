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
 * Test bench para el módulo Elevator
 */

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
    reg [9:0] testvectors [41:0];
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
    //  Se asume que el elevador inicia en el estado a
    begin
        Reset = 1;
        #3 Reset = 0;
        /**
        * La máquina inicia en el estado a
        */
        testvectors[0] = 10'b000_000_000_0;
        /**
        * Se le pide que se mantenga en a indicándole:
        * S0=0, S1=0, S2=0
        */
        testvectors[1] = 10'b000_000_000_0; 
        /**
        * Vaya al estado b, se indica con S0=1
        */
        testvectors[2] = 10'b000_000_100_0;
        /**
        * Del estado b se puede ir a p si E0=1
        */
        testvectors[3] = 10'b000_100_000_0;
        /**
        * Del estado p la transión es incondicional a u y luego a e,
        * donde se evaula R, se le pide que se mantenga en e con R = 0
        * dos veces
        */
        testvectors[4] = 10'b000_000_000_0; 
        testvectors[5] = 10'b000_000_000_0;
        testvectors[6] = 10'b000_000_000_0;
        /**
        * Se le pide que siga hacia el estado a con R = 1
        */
        testvectors[7] = 10'b000_000_000_1;
        testvectors[8] = 10'b000_000_000_1;
        /**
        * Siga hacia b con S0 = 1
        */
        testvectors[9] = 10'b000_000_100_0;
        /**
        * Vaya al estado f, para ello se requiere E0=0, I2=1
        */
        testvectors[10] = 10'b001_000_000_0;
        /**
        * se mantendrá en f mientras que S1=0
        */
        testvectors[11] = 10'b000_000_000_0;
        testvectors[12] = 10'b000_000_000_0;
        /**
        * Partiendo del estado f la máquina transiciona a i cuando S1=1
        */
        testvectors[13] = 10'b000_000_010_0;
        /**
        * En el estado i la máquina se mantiene si S2=0
        */
        testvectors[14] = 10'b000_000_000_0;
        testvectors[15] = 10'b000_000_000_0;
        /**
        * Cuando S2=1 la máquina va al estado p
        */
        testvectors[16] = 10'b000_000_001_0;
        /**
        * Del estado p la llevo al estado a pasando por u, e y t
        * y evaluado R=1 en e.
        */
        testvectors[17] = 10'b000_000_000_1;
        testvectors[18] = 10'b000_000_000_1;
        testvectors[19] = 10'b000_000_000_1;
        /**
        * Del estado a me interesa mandarla de nuevo a b , por lo tanto requiero 
        * S0=1
        */
        testvectors[20] = 10'b000_000_100_0;
        testvectors[21] = 10'b000_000_100_0;
        /**
        * Partiendo del estado b la máquina se queda en b si se evaluan las entradas
        * E0=0, I2=0, E2=0, E1=0, I1=0
        */
        testvectors[22] = 10'b000_000_000_0;
        testvectors[23] = 10'b000_000_000_0;
        /**
        * Partiendo del estado b la máquina irá hacia el estado h si:
        * E0=0, I2=0, E2=0, E1=1
        **/
        testvectors[24] = 10'b000_010_000_0;
        /**
        * Se quedará en h siempre que S1=0
        **/
        testvectors[25] = 10'b000_000_000_0;
        testvectors[26] = 10'b000_000_000_0;
        /**
        * Partiendo del estado h nos vamos para p si S1=1
        **/
        testvectors[27] = 10'b000_000_010_0;
        /**
        * Se repite el proceso de ir del estado p al a
        */
        testvectors[28] = 10'b000_000_000_1;
        testvectors[29] = 10'b000_000_000_1;
        testvectors[30] = 10'b000_000_000_1;
        /**
        * Desde a podemos ir a c siempre que S0=0 y S1=1
        */
        testvectors[31] = 10'b000_000_010_0;
        testvectors[32] = 10'b000_000_010_0;
        /**
        * La máquina se mantiene en el estado c si todas las entradas son cero
        **/
        testvectors[33] = 10'b000_000_000_0;
        testvectors[34] = 10'b000_000_000_0;
        /**
        * Del estado c quiero ir al j, necesito
        * E1=0, I2=0,E2=0,I0=1
        **/
        testvectors[35] = 10'b100_000_000_0;
        /**
        * Del j quiero ir a p y luego al estado a, necesito S0=1
        */
        testvectors[36] = 10'b000_000_100_0;
        testvectors[37] = 10'b000_000_000_1;
        testvectors[38] = 10'b000_000_000_1;
        testvectors[39] = 10'b000_000_000_1;
        testvectors[40] = 10'b000_000_000_0;

        /*
        testvectors[42] = 10'b;
        testvectors[43] = 10'b;
        testvectors[44] = 10'b;
        testvectors[45] = 10'b;
        testvectors[46] = 10'b;
        testvectors[47] = 10'b;
        testvectors[48] = 10'b;
        testvectors[49] = 10'b;

        /**
        *
        **/
        //testvectors[] = 10'b;

        vectornum = 0;


        Reset = 1;
        Clk = 0;

        #5 Reset = 0;
        $dumpfile("Elevator.vcd");
        $dumpvars(0, Elevator_Tester);
    end
    
    /**
    * Se define la señal de reloj
    **/

    always
    begin
        Clk = 1; #5; Clk = 0; #5;  
    end

    always @ (negedge Clk) 
    begin
        {I0, I1, I2, E0, E1, E2, S0, S1, S2, R} = testvectors [vectornum];
        $display;
            $display ("Las entradas son I0=%b, I1=%b, I2=%b, E0=%b, E1=%b, E2=%b, S0=%b, S1=%b, S2=%b, R=%b",I0, I1, I2, E0, E1, E2, S0, S1, S2, R);        
    end

    always @(posedge Clk)
    begin
    #1 if (!Reset)
        begin
            $display ("Las salidas son M=%b, D=%b, P=%b, W=%b, S=%b", M, D, P, W, S);
            vectornum = vectornum + 1;
                if (vectornum == 42/*Cantidad de pruebas*/)
                begin
                    $finish;
                end
        end
    end
endmodule