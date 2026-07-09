module seven_seg_ctrl #(parameter N = 32)(
    input  logic        clk,
    input  logic        rst,
    input  logic [N-1:0] value,

    output logic [3:0]  an,
    output logic [6:0]  seg
);

    logic [16:0] clk_div;
    logic [1:0]  digit_sel;

    always_ff @(posedge clk or posedge rst) begin
        if (rst) clk_div <= 0;
        else     clk_div <= clk_div + 1;
    end

    assign digit_sel = clk_div[16:15];

    logic [3:0] nibble;
    always_comb begin
        case (digit_sel)
            2'b00: nibble = value[3:0];
            2'b01: nibble = value[7:4];
            2'b10: nibble = value[11:8];
            2'b11: nibble = value[15:12];
        endcase
    end

    always_comb begin
        case (digit_sel)
            2'b00: an = 4'b1110;
            2'b01: an = 4'b1101;
            2'b10: an = 4'b1011;
            2'b11: an = 4'b0111;
        endcase
    end

    always_comb begin
        case (nibble)
            4'h0: seg = 7'b1000000;
            4'h1: seg = 7'b1111001;
            4'h2: seg = 7'b0100100;
            4'h3: seg = 7'b0110000;
            4'h4: seg = 7'b0011001;
            4'h5: seg = 7'b0010010;
            4'h6: seg = 7'b0000010;
            4'h7: seg = 7'b1111000;
            4'h8: seg = 7'b0000000;
            4'h9: seg = 7'b0010000;
            4'hA: seg = 7'b0001000;
            4'hB: seg = 7'b0000011;
            4'hC: seg = 7'b1000110;
            4'hD: seg = 7'b0100001;
            4'hE: seg = 7'b0000110;
            4'hF: seg = 7'b0001110;
        endcase
    end

endmodule
