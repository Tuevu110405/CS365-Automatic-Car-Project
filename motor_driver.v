module motor_driver(
    input clk,                  // 50MHz Clock
    input [1:0] cmd,            // Command: 00=Stop, 01=Fwd, 10=Right, 11=Left
    output reg left_IN1,        // To L293D Pin 2
    output reg left_IN2,        // To L293D Pin 7
    output reg right_IN3,       // To L293D Pin 10
    output reg right_IN4,       // To L293D Pin 15
    output wire motor_enable    // To L293D Pin 1 & 9
);

    // 1. Set the Speed (75%)
    pwm_generator speed_control (
        .clk(clk),
        .duty(8'd75),          // <--- CHANGE SPEED HERE (0-100)
        .pwm_out(motor_enable) 
    );

    // 2. Control Direction
    always @(posedge clk) begin
        case(cmd)
            2'b00: begin // STOP
                left_IN1 <= 0; left_IN2 <= 0;
                right_IN3 <= 0; right_IN4 <= 0;
            end
            
            2'b01: begin // FORWARD
                left_IN1 <= 1; left_IN2 <= 0;
                right_IN3 <= 1; right_IN4 <= 0;
            end
            
            2'b10: begin // TURN RIGHT (Tank Turn)
                left_IN1 <= 1; left_IN2 <= 0;
                right_IN3 <= 0; right_IN4 <= 1;
            end
            
            2'b11: begin // TURN LEFT (Tank Turn)
                left_IN1 <= 0; left_IN2 <= 1;
                right_IN3 <= 1; right_IN4 <= 0;
            end
        endcase
    end

endmodule