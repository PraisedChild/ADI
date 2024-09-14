# AHB-Lite MASTER
Owner: Abdelrahman Akram Ibrahim Aly

## DESCRIBTION

AHB-Lite is a parallel bus communication protocol that allows for rapid data transmission and receival by sending the data of the previous interaction with the address of following interaction simultaniously, the MASTER is the unit that allows this communication to run smoothly by informing the slaves of the current state, mode of operation, addresses and the like, as well as handling all the errors, and waiting on slaves to get ready for communication.

## DESIGN
- MIPS Interface: This unit exists in accordance to the system design this master will be used in conjunction with a MIPS Processor, This Unit is responsible for translation of 32 bit MIPS instructions to 4 control signals and 2 address signals that are then sent to the remaining units.

- Controller: This FSM unit is responsible for analyzing the control units received from the interface, and how they would affect the current and next state of the system and its behavior.

- Write Handler: This unit is responsible for sending data, it sends control signals to the register file as well as the address and then receives the data from the register file of the MIPS processor through the DATA line and then forwards it to the Cache Memory on the outside, it receives its control from the Controller unit.

- Read Handler: This unit is responsible for reading data from the cache memory and relaying it to the register file of the MIPS processor, that includes also storing the address of the register it will be written at and sending the control signals to the register to enable it and put it in writing mode.

## FEATURES

***Not all features of AHB-Lite AMBA 3 are included in this design as it is simply for educational purposes***

#### NOT INCLUDED:
- HTRANS
- HRESP (will be included later)
- HSIZE
- INCR4,WRAP4,INCR8,WRAP8

## Sources and Ownership

***This design was made using the AMBA 3 AHB-Lite Document provided by AMD***

All the code and diagrams included in this repo are the making of the Owner only and no help or contribution was made by anyone else.

