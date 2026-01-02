module robot_top (
    input  wire clk,            // 50MHz System Clock (PIN_23)
    input  wire reset_n,        // Reset Button (PIN_25)
    input  wire ir_left_raw,    // Sensor Input Left (PIN_87)
    input  wire ir_right_raw,   // Sensor Input Right (PIN_86)
    
    // Motor Outputs (To L293D)
    output wire IN1,            // Left Motor +
    output wire IN2,            // Left Motor -
    output wire IN3,            // Right Motor +
    output wire IN4,            // Right Motor -
    output wire ENA,            // Motor PWM (Shared or Left)
    output wire ENB             // Motor PWM (Shared or Right)
);

    // --- Internal Wires ---
    wire obstacle_left_wire;
    wire obstacle_right_wire;
    wire [1:0] command_wire;    // The 2-bit command: 00=Stop, 01=Fwd...
    wire speed_pwm;             // The speed signal

    // 1. The Eyes (Sensor Interface)
    ir_sensor_if u_sensors (
        .clk            (clk),
        .reset_n        (reset_n),
        .ir_left_raw    (ir_left_raw),
        .ir_right_raw   (ir_right_raw),
        .obstacle_left  (obstacle_left_wire),
        .obstacle_right (obstacle_right_wire)
    );

    // 2. The Brain (Finite State Machine)
    robot_fsm u_brain (
        .clk            (clk),
        .reset_n        (reset_n),
        .obstacle_left  (obstacle_left_wire),
        .obstacle_right (obstacle_right_wire),
        .cmd            (command_wire)  
    );

    // 3. The Legs (Motor Driver)
    motor_driver u_legs (
        .clk          (clk),
        .cmd          (command_wire),   
        .left_IN1     (IN1),
        .left_IN2     (IN2),
        .right_IN3    (IN3),
        .right_IN4    (IN4),
        .motor_enable (speed_pwm)       
    );

    // 4. Wiring the Speed to L293D Enable Pins
    assign ENA = speed_pwm;
    assign ENB = speed_pwm;

endmodule