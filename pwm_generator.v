module pwm_generator(
    input clk,             // 50MHz Clock from Altera Board
    input [7:0] duty,      // Speed (0 to 100)
    output reg pwm_out     // Resulting signal to L293D Enable Pin
);

    // 50MHz / 50000 = 1kHz Frequency
    parameter PERIOD = 50000; 
    
    integer counter = 0;

    always @(posedge clk) begin
        // Counter Logic
        if (counter < PERIOD - 1) 
            counter <= counter + 1;
        else 
            counter <= 0;

        // Comparator Logic (0-100% duty cycle)
        if (counter < (duty * 500)) 
            pwm_out <= 1;
        else 
            pwm_out <= 0;
    end

endmodule