# Exp-No: 01 - 4:1 Multiplexer using Verilog HDL (Gate-Level, Dataflow, Behavioural, and Structural Modelling)

**Aim:** <br>
<br>
&emsp;&emsp;To design and simulate a 4:1 Multiplexer (MUX) using Verilog HDL in four different modeling styles—Gate-Level, Data Flow, Behavioral, and Structural and to verify its functionality through a testbench using the Vivado 2023.1 simulation environment. The experiment aims to understand how different abstraction levels in Verilog can be used to describe the same digital logic circuit and analyze their performance.<br>
<br>
**Apparatus Required:** <br>
<br>
&emsp;&emsp;Vivado 2023.1<br>
<br>
**Procedure:** <br>
<br>
1. Launch Vivado Open Vivado 2023.1 by double-clicking the Vivado icon or searching for it in the Start menu.<br>
2. Create a New Project Click on "Create Project" from the Vivado Quick Start window. In the New Project Wizard: Project Name: Enter a name for the project (e.g., Mux4_to_1). Project Location: Select the folder where the project will be saved. Click Next. Project Type: Select RTL Project, then click Next. Add Sources: Click on "Add Files" to add the Verilog files (e.g., mux4_to_1_gate.v, mux4_to_1_dataflow.v, etc.). Make sure to check the box "Copy sources into project" to avoid any external file dependencies. Click Next. Add Constraints: Skip this step by clicking Next (since no constraints are needed for simulation).
Default Part Selection: You can choose a part based on the FPGA board you are using (if any). If no board is used, you can choose any part, for example, xc7a35ticsg324-1L (Artix-7). Click Next, then Finish.<br>
3. Add Verilog Source Files In the "Sources" window, right-click on "Design Sources" and select Add Sources if you didn't add all files earlier. Add the Verilog files (mux4_to_1_gate.v, mux4_to_1_dataflow.v, etc.) and the testbench (mux4_to_1_tb.v).<br>
4. Check Syntax Expand the "Flow Navigator" on the left side of the Vivado interface. Under "Synthesis", click "Run Synthesis". Vivado will check your design for syntax errors. If any errors or warnings appear, correct them in the respective Verilog files and re-run the synthesis.<br>
5. Simulate the Design In the Flow Navigator, under "Simulation", click on "Run Simulation" → "Run Behavioral Simulation". Vivado will open the Simulations Window, and the waveform window will show the signals defined in the testbench.<br>
6. View and Analyze Simulation Results The simulation waveform window will display the signals (S1, S0, A, B, C, D, Y_gate, Y_dataflow, Y_behavioral, Y_structural). Use the time markers to verify the correctness of the 4:1 MUX output for each set of inputs. You can zoom in/out or scroll through the simulation time using the waveform viewer controls.<br>
7. Adjust Simulation Time To run a longer simulation or adjust timing, go to the Simulation Settings by clicking "Simulation" → "Simulation Settings".
Under "Simulation", modify the Run Time (e.g., set to 1000ns).<br>
8. Generate Simulation Report Once the simulation is complete, you can generate a simulation report by right-clicking on the simulation results window and selecting "Export Simulation Results". Save the report for reference in your lab records.<br>
9. Save and Document Results Save your project by clicking File → Save Project. Take screenshots of the waveform window and include them in your lab report to document your results. You can include the timing diagram from the simulation window showing the correct functionality of the 4:1 MUX across different select inputs and data inputs.<br>
10. Close the Simulation Once done, by going to Simulation → "Close Simulation<br>
<br>

**Logic Diagram:** <br>
<br>

![368836171-d4ab4bc3-12b0-44dc-8edb-9d586d8ba856](https://github.com/user-attachments/assets/335554b2-6dde-4d52-b34d-d1c711e330ad)

<br>

**Truth Table:** <br>
<br>

![368836230-c850506c-3f6e-4d6b-8574-939a914b2a5f](https://github.com/user-attachments/assets/ef7b428a-a74c-4ee4-9681-d89e5ad2ec35)

<br>

**Verilog Code:** <br>
**4:1 MUX Gate-Level Implementation:**
```
module fom(a,s,out);
input [3:0]a;
input [1:0]s;
output out;
wire [3:0]w;
and (w[0],a[0],~s[1],~s[0]);
and (w[1],a[1],~s[1],s[0]);
and (w[2],a[2],s[1],~s[0]);
and (w[3],a[3],s[1],s[0]);
or (out,w[0],w[1],w[2],w[3]);
endmodule

```
**4:1 MUX Data Flow Implementation:**
```
module mux4to1_dataflow (
    output y,
    input i0, i1, i2, i3,
    input s0, s1
);

assign y = (~s1 & ~s0 & i0) |
           (~s1 &  s0 & i1) |
           ( s1 & ~s0 & i2) |
           ( s1 &  s0 & i3);

endmodule

```

**4:1 MUX Behavioral Implementation:**
```
module behavemux(
    output reg y,
    input [3:0] i,
    input [1:0] s
);

    always @(*) begin
        case(s)
            2'b00: y = i[0];
            2'b01: y = i[1];
            2'b10: y = i[2];
            2'b11: y = i[3];
            default: y = 1'bx; // Optional: Handles unknown select inputs
        endcase
    end
endmodule
```

**4:1 MUX Structural Implementation:** <br>
```
// 2:1 MUX Component
module mux2to1 (y, a, b, s);
  input a, b, s;
  output y;
  assign y = (s==0)? a : b;
endmodule

// 4:1 MUX Structural using 2:1 MUX
module mux4to1_structural (y, i, s);
  // Input i is a 4-bit vector (i[3], i[2], i[1], i[0])
  // Input s is a 2-bit vector (s[1], s[0])
  input [3:0] i; 
  input [1:0] s;
  output y;
  wire y0, y1;

  // m1 selects between i[0] and i[1] based on s[0]
  mux2to1 m1(y0, i[0], i[1], s[0]);
  // m2 selects between i[2] and i[3] based on s[0]
  mux2to1 m2(y1, i[2], i[3], s[0]);
  // m3 selects between y0 and y1 based on s[1]
  mux2to1 m3(y, y0, y1, s[1]);
endmodule
```

**Testbench Implementation:**
**4:1 MUX Gate-Level Implementation:**
```
`timescale 1ns / 1ps
module fom_tb;

    reg [3:0] a;
    reg [1:0] s;
    wire out;

    // Assuming your design module is named `mux_4_1_behavioral` from the image
    fom uut (
        .a(a),
        .s(s),
        .out(out)
    );

    initial begin
        $dumpfile("exact_match.vcd");
        $dumpvars(0, fom_tb);

        // Initial values at t=0
        a = 4'b0000;
        s = 2'b00;

        // Apply stimuli to match the exact sequence from the waveform image
        #2 {s, a} = 6'b00_0001;
        #2 {s, a} = 6'b01_0010;
        #2 {s, a} = 6'b10_0100;
        #2 {s, a} = 6'b11_1000;
        #2 {s, a} = 6'b01_1100;
        #2 {s, a} = 6'b10_1010;
        #2 {s, a} = 6'b11_0110;
        #2 {s, a} = 6'b00_1111;

        #2 $finish;
    end

    initial begin
        $monitor("Time=%0t | s=%b | a=%b | out=%b", $time, s, a, out);
    end

endmodule
```
**4:1 MUX Data Flow Implementation:**
```
`timescale 1ns / 1ps

module tb_mux4to1_dataflow;

    reg i0, i1, i2, i3;
    reg s0, s1;
    wire y;

    mux4to1_dataflow uut (.y(y), .i0(i0), .i1(i1), .i2(i2), .i3(i3), .s0(s0), .s1(s1));

    initial begin
        i0=0; i1=0; i2=0; i3=0; s0=0; s1=0;
        #10 i0=1; s0=0; s1=0;
        #10 i1=1; s0=1; s1=0;
        #10 i2=1; s0=0; s1=1;
        #10 i3=1; s0=1; s1=1;
        #10 $finish;
    end

    initial begin
        $monitor("Time=%0t | s1=%b s0=%b | i0=%b i1=%b i2=%b i3=%b | y=%b",
                 $time, s1, s0, i0, i1, i2, i3, y);
    end

endmodule

```

**4:1 MUX Behavioral Implementation:**
```
module behavemux_tb;

    // Declare signals as vectors
    reg [3:0] i;
    reg [1:0] s;
    wire y;

    // Instantiate the Device Under Test (DUT)
    behavemux dut (
        .y(y),
        .i(i),
        .s(s)
    );

    initial begin
        // Monitor the signals
        $monitor("s=%b i=%b => y=%b", s, i, y);

        // Set initial input values
        i = 4'b1010;

        // Apply stimuli for each select combination
        s = 2'b00; #10;
        s = 2'b01; #10;
        s = 2'b10; #10;
        s = 2'b11; #10;

        $finish; // End the simulation
    end
endmodule
```

**4:1 MUX Structural Implementation:** <br>
```
// Test Bench
module tb_mux4to1_structural;
  // Declare inputs as vectors
  reg [3:0] i;
  reg [1:0] s;
  wire y;

  // Instantiate the DUT with vector inputs
  mux4to1_structural dut(.y(y), .i(i), .s(s));

  initial begin
    // Monitor the signals using vector notation
    $monitor("s=%b i=%b => y=%b", s, i, y);

    // Set all data inputs at once
    i = 4'b0101; 

    // Apply stimuli for each select combination
    s = 2'b00; #10;
    s = 2'b01; #10;
    s = 2'b10; #10;
    s = 2'b11; #10;

    $finish;
  end
endmodule
```
**Sample Output:**
```

Time=00 | s[1]=0 s[0]=0 | Inputs: a[0]=0 a[1]=0 a[2]=0 a[3]=0
        | out_gate=0 | out_dataflow=0 | out_behavioral=0 | out_structural=0
Time=04 | s[1]=0 s[0]=0 | Inputs: a[0]=1 a[1]=0 a[2]=0 a[3]=0
        | out_gate=1 | out_dataflow=1 | out_behavioral=1 | out_structural=1
Time=06 | s[1]=0 s[0]=1 | Inputs: a[0]=0 a[1]=1 a[2]=0 a[3]=0
        | out_gate=1 | out_dataflow=1 | out_behavioral=1 | out_structural=1
Time=08 | s[1]=1 s[0]=0 | Inputs: a[0]=0 a[1]=0 a[2]=1 a[3]=0
        | out_gate=1 | out_dataflow=1 | out_behavioral=1 | out_structural=1
Time=10 | s[1]=1 s[0]=1 | Inputs: a[0]=0 a[1]=0 a[2]=0 a[3]=1
        | out_gate=1 | out_dataflow=1 | out_behavioral=1 | out_structural=1
Time=12 | s[1]=0 s[0]=1 | Inputs: a[0]=0 a[1]=0 a[2]=1 a[3]=1
        | out_gate=0 | out_dataflow=0 | out_behavioral=0 | out_structural=0
Time=14 | s[1]=1 s[0]=0 | Inputs: a[0]=0 a[1]=1 a[2]=0 a[3]=1
        | out_gate=0 | out_dataflow=0 | out_behavioral=0 | out_structural=0
Time=16 | s[1]=1 s[0]=1 | Inputs: a[0]=0 a[1]=1 a[2]=1 a[3]=0
        | out_gate=0 | out_dataflow=0 | out_behavioral=0 | out_structural=0
Time=18 | s[1]=0 s[0]=0 | Inputs: a[0]=1 a[1]=1 a[2]=1 a[3]=1
        | out_gate=1 | out_dataflow=1 | out_behavioral=1 | out_structural=1

```
**Output waveform**
**Gate Level**
<img width="1920" height="1080" alt="Screenshot 2025-09-02 175315" src="https://github.com/user-attachments/assets/7885795c-5d66-486e-92e9-d213e5a884a4" />

**Data Flow**
<img width="1920" height="1080" alt="Screenshot 2025-09-02 175911" src="https://github.com/user-attachments/assets/9e0136db-9bb0-4eab-85da-9f449905d16d" />

**Behavioral**
<img width="1920" height="1080" alt="Screenshot 2025-09-02 180033" src="https://github.com/user-attachments/assets/e91c9834-1c11-447e-86f7-74bc0c0ff007" />

**Structural**
<img width="1920" height="1080" alt="Screenshot 2025-09-02 180212" src="https://github.com/user-attachments/assets/4bd29749-2a4a-43cb-8267-bf793e1db95a" />


**Conclusion:** <br>
<br>
&emsp;&emsp;In this experiment, a 4:1 Multiplexer was successfully designed and simulated using Verilog HDL across four different modeling styles: Gate-Level, Data Flow, Behavioral, and Structural. The simulation results verified the correct functionality of the MUX, with all implementations producing identical outputs for the given input conditions.



  
