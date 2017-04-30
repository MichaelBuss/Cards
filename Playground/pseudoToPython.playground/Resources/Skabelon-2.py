#!/usr/bin/env python3
from ev3dev.auto import *

# Connect sensors.
ts = TouchSensor();    assert ts.connected
cs = ColorSensor();    assert ts.connected
cs.mode = 'COL-COLOR'
us = UltrasonicSensor();    assert ts.connected
us.mode = 'US-DIST-CM' # reports 'cm' even though the sensor measures 'mm'
btn = Button()
mB = LargeMotor('outB')
mC = LargeMotor('outC')
mA = MediumMotor('outA')

# Variables
rotationmm = 183 # One wheel rotation equals x mm. From configure panel in app. Can be static for now
rotationdeg = 210 # One wheel rotation in opposite directions equals the robot turning x degrees. From configure panel in app. Can be static for now
driveRatio = (360/(rotationmm))*10
turnRatio = 360/rotationdeg

Sound.speak('Starting').wait()

def drive(unit="degrees", amount=360, speed=50, direction=1):
	# unit = degrees, seconds, rotations, cm
	# amount = any int
	# speed = 0-100
	# direction = +/-1
	speed = speed*direction*10 # Because ev3dev motors gros from -1000 to +1000
	
	if unit == "degrees":
		# run_to_rel_pos is the only one that don't react to negative speed, thus *direction on position instead
		mB.run_to_rel_pos(position_sp=amount*direction, speed_sp=speed, stop_action="brake")
		mC.run_to_rel_pos(position_sp=amount*direction, speed_sp=speed, stop_action="brake")
		mB.wait_while('running')
		mC.wait_while('running')
	elif unit == "seconds":
		amount = amount*1000 # Because ev3dev uses milliseconds
		mB.run_timed(time_sp=amount, speed_sp=speed, stop_action="brake")
		mC.run_timed(time_sp=amount, speed_sp=speed, stop_action="brake")
		mB.wait_while('running')
		mC.wait_while('running')
	elif unit == "rotations":
		mB.run_to_rel_pos(position_sp=amount*direction*360, speed_sp=speed, stop_action="brake")
		mC.run_to_rel_pos(position_sp=amount*direction*360, speed_sp=speed, stop_action="brake")
		mB.wait_while('running')
		mC.wait_while('running')
	elif unit == "cm":
		# run_to_rel_pos is the only one that don't react to negative speed, thus *direction on position instead
		mB.run_to_rel_pos(position_sp=amount*direction*driveRatio, speed_sp=speed, stop_action="brake")
		mC.run_to_rel_pos(position_sp=amount*direction*driveRatio, speed_sp=speed, stop_action="brake")
		mB.wait_while('running')
		mC.wait_while('running')
	else:
		mB.run_forever(speed_sp=speed, stop_action="brake")
		mC.run_forever(speed_sp=speed, stop_action="brake")
		


def turn(unit ="degrees" ,amount=90, speed=50, direction=1):
	if unit == "degrees":
		speed = speed*10 # Because ev3dev motors gros from -1000 to +1000
		# run_to_rel_pos is the only one that don't react to negative speed, thus *direction on position instead
		mB.run_to_rel_pos(position_sp=amount*turnRatio*direction, speed_sp=speed, stop_action="brake")
		mC.run_to_rel_pos(position_sp=amount*turnRatio*-direction, speed_sp=speed, stop_action="brake")
		mB.wait_while('running')
		mC.wait_while('running')
	
	
def toWall():
	while not ts.value():
		drive(unit="forever")
	drive(unit="cm", amount=6, speed=50, direction=-1)
		
while not btn.backspace: # Exits program
#	Task 1
	drive(unit="cm", amount=10, speed=50, direction=1)
	Sound.speak('Hellow').wait()
	
#	Task 2
	toWall()
	turn(amount=90, speed=50, direction=1)
	toWall()

#	Task 3
	for i in range(0,3):
		turn(amount=50, speed=50, direction=1)
		Sound.speak('Right').wait()
		turn(amount=20, speed=50, direction=-1)
		Sound.speak('Left').wait()
	drive(unit="seconds", amount=1, speed=50, direction=-1)
	while not ts.value():
		drive(unit="forever")
	mB.stop(stop_action="brake")
	mC.stop(stop_action="brake")

#	Task 4
	if cs.value() == 5:
		mA.run_to_rel_pos(position_sp=360, speed_sp=50*10, stop_action="brake")
		mA.wait_while('running')
	elif cs.value() == 1:
		mA.run_to_rel_pos(position_sp=-360, speed_sp=50*10, stop_action="brake")
		mA.wait_while('running')
	else:
		break
	drive(unit="cm", amount=6, speed=50, direction=-1)
	turn(amount=90, speed=50, direction=-1)
	
#	Task 5
	while not ts.value():
		if cs.value() == 5 or us.value()/10 <= 20:
			mB.stop(stop_action="brake")
			mC.stop(stop_action="brake")
		else:
			drive(unit="forever")
	mB.stop(stop_action="brake")
	mC.stop(stop_action="brake")	
	drive(unit="cm", amount=6, speed=50, direction=-1)
	turn(amount=90, speed=50, direction=-1)
	drive(unit="seconds", amount=1, speed=50, direction=-1)
	
#	Task 6
	mB.reset() # Resets motor before measuring
	mC.reset() # Resets motor before measuring
	while not ts.value():
		drive(unit="forever")
	mB.stop(stop_action="brake")
	mC.stop(stop_action="brake")
	measuredDist = abs(mB.position)/driveRatio # New user made variable. Measured in positive cm number.
	drive(unit="cm", amount=6, speed=50, direction=-1)
	turn(amount=90, speed=50, direction=-1)
	drive(unit="seconds", amount=1, speed=50, direction=-1)
	drive(unit="cm", amount=measuredDist, speed=50, direction=1)
	
	break

mB.stop(stop_action="brake")
mC.stop(stop_action="brake")
exit()