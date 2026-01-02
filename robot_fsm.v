module robot_fsm (
    input  wire clk,
    input  wire reset_n,
    input  wire obstacle_left,
    input  wire obstacle_right,
    output reg [1:0] cmd  // 00=Stop, 01=Fwd, 10=Right, 11=Left
);

    // Command Codes
    localparam CMD_STOP    = 2'b00;
    localparam CMD_FORWARD = 2'b01;
    localparam CMD_RIGHT   = 2'b10;
    localparam CMD_LEFT    = 2'b11;

    reg [1:0] state, next_state;

    // State Register
    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) state <= CMD_STOP;
        else          state <= next_state;
    end

    // Logic: Read Sensors -> Choose Next Move
    always @(*) begin
        case (state)
            CMD_STOP: begin
                 // If no obstacles, go forward
                 if (!obstacle_left && !obstacle_right) next_state = CMD_FORWARD;
                 else next_state = CMD_STOP;
            end
            CMD_FORWARD: begin
                if (obstacle_left && obstacle_right) next_state = CMD_STOP;
                else if (obstacle_left)              next_state = CMD_RIGHT;
                else if (obstacle_right)             next_state = CMD_LEFT;
                else                                 next_state = CMD_FORWARD;
            end
            CMD_LEFT: begin
                // Keep turning until right is clear
                if (!obstacle_right) next_state = CMD_FORWARD;
                else                 next_state = CMD_LEFT;
            end
            CMD_RIGHT: begin
                // Keep turning until left is clear
                if (!obstacle_left)  next_state = CMD_FORWARD;
                else                 next_state = CMD_RIGHT;
            end
            default: next_state = CMD_STOP;
        endcase
    end

    // Output the decision
    always @(*) begin
        cmd = state; 
    end

endmodule