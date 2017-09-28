# digital-systems-lab5

EGRE 365 Digital Systems
Lab #5 – 8-bit adder delay modeling
Assume that the 8-bit adder from example 9 is going to be used in the Arithmetic Logic
Unit (ALU) for a new processor. Your next task is to determine the worst-case delay of the
adder. This information will be used to determine the maximum clock speed of the
processor. You have information (from perhaps a datasheet or modeling by other members
of the implementation team) on the average delay of each type of logic operation. The
average delays are as follows:
Logical Operation Average Delay
 NOT (inversion) 3 ns
 AND 4 ns
 OR 5 ns
 XOR 7 ns
1) Modify the N-bit adder from example 9 to include the delays shown above. Be sure to
incorporate the correct delays into each signal assignment statement. Note that, just as in
C and C++ programming, it is not good to have “magic numbers” inline in your code.
2) Modify the example 9 8-bit adder testbench to test the maximum delay for this version
of the adder model. Note that the overall delay for an addition operation is dependent on
the inputs to the adder. Be sure to set the operands to value(s) that generate the maximum
delays. Hint: look at the carry values between the individual bits of the output. Note that
you will have to change the value of the MAX_DELAY constant in the testbench to allow
enough time for the outputs of the adder to settle to the correct values.
Measure the maximum delay of the adder and use that to calculate the maximum clock
speed of the processor
3) Assume that the goal is to be able to run the processor at a clock speed of 20 MHz.
Calculate the maximum delay of the adder to achieve this clock speed. Use that maximum
delay to estimate the delays for each logic operation that will achieve the required result.
Simulate the resulting model to show that it does in fact, meet the requirement. Which
operation’s delay has the most impact on the overall delay of the subtraction operation?
4) Turn in a full lab report as outlined in the course syllabus. The lab writeup should include
a discussion of the results you achieved for the above questions.
