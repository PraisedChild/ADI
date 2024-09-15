# Moving Average Filter - Verilog Documentation

**Owner:** Abdelrahman Akram Ibrahim Aly

## Project Overview

This project implements a **Moving Average Filter** in Verilog, designed to smooth out a signal by taking the weighted average of the most recent input samples. The filter is an essential component in digital signal processing, especially for noise reduction and signal smoothing.

### Key Features:
- **Input Width:** 8 bits
- **Output Width:** 8 bits
- **Weighted Moving Average:** The filter applies the following weights to the input samples:
  - 1 (for the current sample)
  - 0.5 (for the previous sample)
  - 0.25 (for the second previous sample)
  - 0.125 (for the third previous sample)

This weighting scheme ensures that the most recent input has the greatest influence on the output, while older inputs have progressively less influence, providing a smooth filtering effect.

### Functionality:
- **Inputs:** 
  - The 8-bit input signal represents the raw data that needs to be filtered.
- **Outputs:** 
  - The 8-bit output signal is the weighted moving average of the recent inputs.

### Applications:
The Moving Average Filter is particularly useful in systems where noise reduction or signal smoothing is needed, such as:
- Audio processing
- Sensor data smoothing
- Control systems where short-term fluctuations should be ignored

The design is compact and efficient, making it suitable for both hardware implementations and FPGA-based systems.