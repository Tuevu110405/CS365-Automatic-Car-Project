module ir_sensor_if (
    input  wire clk,
    input  wire reset_n,
    input  wire ir_left_raw, 
    input  wire ir_right_raw,
    output reg  obstacle_left, 
    output reg  obstacle_right
);

    // Invert the signal if your sensor is Active LOW (0 = Object)
    // Most IR modules output 0 when they see something.
    always @(posedge clk) begin
        obstacle_left  <= !ir_left_raw; 
        obstacle_right <= !ir_right_raw;
    end

endmodule