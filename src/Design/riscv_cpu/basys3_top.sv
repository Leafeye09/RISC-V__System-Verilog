`timescale 1ns/1ps
module basys3_top #(parameter N = 32)(
    input  logic        clk,btnC,       
    input  logic [4:0]  sw,         // SW[4:0] = register select
    output logic [3:0]  an,         // 7-segment digit select
    output logic [6:0]  seg,        // 7-segment segments
    output logic [4:0]  led         // shows selected register number
);
    logic [N-1:0] reg_data;
    // instantiate CPU
    top_level #(.N(N)) cpu (
        .clk(clk),
        .rst(btnC),
        .reg_sel(sw),
        .reg_out(reg_data)
    );
    assign led = sw;

    seven_seg_ctrl seg_ctrl (
        .clk  (clk),
        .rst  (btnC),
        .value(reg_data),
        .an   (an),
        .seg  (seg)
    );

endmodule
