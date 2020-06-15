#/bin/bash

# http://ww1.microchip.com/downloads/en/DeviceDoc/20001952C.pdf



POSITIONAL=()

# default values for I2C BUS, DEVICE and options
BUS=1
DEVICE=0x20
DETECT=0
INIT=0
SERIAL=-1
POWER=0
CARD=-2

# read options from command line
while [[ $# -gt 0 ]]
do
	key="$1"

	case $key in
	-b|--bus)   # this has to be I2C bus as in /dev/i2c-
		BUS=$2
		shift
		shift
		;;
	-a|--address)
		DEVICE=$2
		shift
		shift
		;;
	-d|--detect)
	    	DETECT=1
		shift # past argument
		;;
	-i|--init)
		INIT=1
		shift # argument
		;;
	-s|--serial)
		SERIAL=$2
		shift # argument
		shift # value
		;;
	-c|--card)
                CARD=$2
                shift # argument
                shift # value
                ;;
	--pon)
		# ports range from 0 to 7, when turning on increase by one to get from 1 to 8
		POWER=$(($2+1))
		shift
		shift
		;;
	--poff)
		# ports range from 0 to 7, when turning off invert sign, decrease by one to get from -1 to -8
		POWER=$((0-$2-1))
		shift
		shift
		;;
	*)    # unknown option
		POSITIONAL+=("$1") # save it in an array for later
		shift # past argument
		;;
	esac
done

set -- "${POSITIONAL[@]}" # restore positional parameters

echo "Using device $DEVICE on i2c bus $BUS"

if [[ $DETECT -eq 1 ]]
then
	# detect i2c devices on bus
	echo "Running i2cdetect on i2c bus $DEVICE"
	i2cdetect -y $BUS
fi

if [[ $INIT -eq 1 ]]
then
	# set all pins as outputs
	echo "Initializing MCP23017 on i2c bus $DEVICE"
	i2cset -y $BUS $DEVICE 0x0 0x0
	i2cset -y $BUS $DEVICE 0x1 0x0
	i2cset -y -m 0xF0 $BUS $DEVICE 0x12 0x80 # value 0x80 turns enable pin high -> disable sd master
fi

if [[ $SERIAL -gt -1 ]]
then
	# only change lowest 3 bits, read other bits from devices
	echo "Selecting serial $SERIAL"
	i2cset -y -m 0x07 $BUS $DEVICE 0x12 $SERIAL
fi

if [[ $POWER -gt 0 ]]
then
	POWER=$(($POWER-1))
	MASK=$((1<<$POWER)) # calculate bitmask
	echo "Turning on port $POWER"
	i2cset -y -m $MASK $BUS $DEVICE 0x13 0xFF
fi

if [[ $POWER -lt 0 ]]
then
	POWER=$((0-$POWER-1))
	MASK=$((1<<$POWER))
	echo "Turning off port $POWER"
	i2cset -y -m $MASK $BUS $DEVICE 0x13 0x0
fi

if [[ $CARD -eq -1 ]]
then
	echo "Disconnecting card from master; all cards on slaves"
	# use -m 0xF0 to only update highbyte, read rest from device
	i2cset -y -m 0xF0 $BUS $DEVICE 0x12 0x80 # value 0x80 turns enable pin high -> disable sd master
fi

if [[ $CARD -gt -1 ]]
then
	echo "Connecting card $CARD to master, disconnecting from slave"
	CARD=$(($CARD&0x07)) # make sure only lowest 3 bits are used, rest is set to zero
	CARD=$(($CARD<<4)) # shift to highbyte
	i2cset -y -m 0xF0 $BUS $DEVICE 0x12 $CARD # use -m 0xF0 to only update highbyte, read rest from device
fi

