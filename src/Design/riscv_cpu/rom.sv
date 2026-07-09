module rom #(parameter N = 32)(
    input  logic [N-1:0] addr,
    output logic [N-1:0] instr
);
    logic [N-1:0] memory [0:255];

    initial begin
        memory[0]  = 32'h00500093; 
        memory[1]  = 32'h00300113; 
        memory[2]  = 32'h002081B3; 
        memory[3]  = 32'h40208233; 
        memory[4]  = 32'h0020F2B3; 
        memory[5]  = 32'h0020E333; 
        memory[6]  = 32'h0020C3B3; 
        memory[7]  = 32'h00209433; 
        memory[8]  = 32'h002454B3; 
        memory[9]  = 32'h40245533; 
        memory[10] = 32'h0020A5B3; 
        memory[11] = 32'h00112633; 
        memory[12] = 32'hFFF00693; 
        memory[13] = 32'h0016A733; 
        memory[14] = 32'h0016B7B3; 
        memory[15] = 32'h00000073; 

        for (int i = 16; i < 256; i++)
            memory[i] = 32'h00000013;
    end

    assign instr = memory[addr[9:2]];

endmodule
