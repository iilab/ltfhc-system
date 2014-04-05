# Locations

## Nkasi Checklist

 * All Systems - Routine Check
 * Radio - Diagnostic
   * Run Diagnostic Call to Kirando / Izinga / Kasovu / Namansi
 * 3G - Diagnostic
 * 3G - Troubleshooting 

## Kirando Checklist

 * All Systems - Routine Check
 * Power - Deployment / Upgrade
 * Radio - Diagnostic
   * Run Diagnostic Call to Nkasi
  
# Checklists

## Routine Checklists

### Power System

#### Check #1 - Visual inspection.

There are no **burns, leaks, corrosion or any other traces of damage** on the solar charger and power connectors.

#### Check #2 - Cables are solidly connected. 

**Pull very lightly on the cables** to check that there are no loose connectors.

#### Check #3 - Radio Handset Screen must be on.

![](/docs/img/handset_screen.png)

#### Check #4 - Modem Power LED must be green

![](/docs/img/modem.png)

#### Check #5 - Server Power LED must be green

![](/docs/img/power.png)

### Radio System

#### Check #1 - Channel Test Call

This will check the quality of the line with 

 * Press **CALL**
 * Select **Channel Test?** as the call type
 
![](/docs/img/channel_test.png)

 * Select a station to call from this list and press **CALL**

> **Station addresses**
- Kirando - 12301
- Nkasi - 12302
- Izinga - 12303
- Kasovu - 12304
- Namansi - 12305

 * Listen for the revertive signal from the other station. The volume and clarify of this signal indicates the quality of the channel/mode.

#### Check #2 - Power drain verification

Make a Call and check that the Server is not rebooting due to insufficient current.

 * Press **CALL**
 * Select **Selective Call** as the call type
 
![](/docs/img/selective_call.png)

 * Select a station to call from this list and press **CALL**

> **Station addresses**
- Kirando - 12301
- Nkasi - 12302
- Izinga - 12303
- Kasovu - 12304
- Namansi - 12305

 * Observe if the **Power LED on Server stays green**

![](/docs/img/power.png)



### Server System

 * 
  * Trigger UUCP file transfer. Observe shutdown.

### 3G System


 * Radio System
 * Server System
 * 3G System

## Diagnostic Checklists

### Power System

 * Use Putty to connect to the Server.
 * Insert the flash drive.
 * Mount the flash drive
> sudo mkdir /media/usb
> sudo mount -t vfat /dev/sdb1 /media/usb

 * Execute script
 * /media/usb/ltfhc-system/scripts/solar.py

### Radio System

  * Press **CALL**
  * Select **Get Status Call**
  
![](/docs/img/get_status_call.png)

### Modem System

  * Connect to modem via serial port. (see p.23 of HF Data Modem 3212 User Guide).
  
![](/docs/img/modem_pc.png)

  * Use Putty in Serial mode to connect.
  * Type ATD<remote address> then Enter
  * If the link is established the Link LEDs change to solid color and **CONNECT** appears in the terminal.

### Server System

  * Connect via Ethernet cable to the LAN2 port 
  * Use putty 


  * Check system version. Update files. Restart.

  * Trigger UUCP file transfer.



### 3G System
  * 3G (check credits)

## Troubleshooting Checklists

Click the handset power button to power on the radio.
![](/docs/img/handset.png)

## Repair Checklists

## Deployment Checklists

### Power System

#### Installation

 * Separate power from signal cables on HF setup.

 * Documentation 
   * Take pictures of the connections.

#### Update

 * Documentation 
   * Take pictures of the connections.

### Server System

 * Documentation 
   * Take pictures of the connections.

#### Installation

#### Update


